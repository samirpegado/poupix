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
    const { email } = await req.json();

    if (!email?.trim()) {
      return errorResponse("E-mail é obrigatório.");
    }

    const normalizedEmail = email.trim().toLowerCase();
    const supabase = createAdminClient();

    const { data: user } = await supabase
      .from("users")
      .select("id, email")
      .eq("email", normalizedEmail)
      .maybeSingle();

    if (user?.id && user.email) {
      const otp = generateOtp();
      await storeOtp(supabase, user.id, otp);
      await sendOtpEmail(user.email, otp, "recovery");
    }

    return successResponse(
      "Se o e-mail estiver cadastrado, enviaremos um código de recuperação.",
    );
  } catch (error) {
    console.error("[recover-password-mobile]", error);
    const message = error instanceof Error
      ? error.message
      : "Erro ao processar recuperação de senha.";
    return errorResponse(message, 500);
  }
});
