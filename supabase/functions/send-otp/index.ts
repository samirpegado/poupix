import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { handleCors } from "../_shared/cors.ts";
import { sendOtpEmail } from "../_shared/email.ts";
import { generateOtp, storeOtp } from "../_shared/otp.ts";
import { errorResponse, successResponse } from "../_shared/response.ts";
import { createAdminClient } from "../_shared/supabase.ts";

Deno.serve(async (req) => {
  const cors = handleCors(req);
  if (cors) return cors;

  if (req.method !== "POST") {
    return errorResponse("Método não permitido.", 405);
  }

  try {
    const { user_id: userId } = await req.json();

    if (!userId) {
      return errorResponse("Usuário não informado.");
    }

    const supabase = createAdminClient();

    const { data: user, error: userError } = await supabase
      .from("users")
      .select("id, email, status")
      .eq("id", userId)
      .maybeSingle();

    if (userError || !user?.email) {
      return errorResponse("Usuário não encontrado.");
    }

    if (user.status === true) {
      return successResponse("Conta já verificada.");
    }

    const otp = generateOtp();
    await storeOtp(supabase, userId, otp);
    await sendOtpEmail(user.email, otp, "verify");

    return successResponse("Código enviado para o seu e-mail.");
  } catch (error) {
    console.error("[send-otp]", error);
    const message = error instanceof Error
      ? error.message
      : "Erro ao enviar código.";
    return errorResponse(message, 500);
  }
});
