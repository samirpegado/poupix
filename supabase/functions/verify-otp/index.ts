import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { handleCors } from "../_shared/cors.ts";
import { clearOtp, validateOtp } from "../_shared/otp.ts";
import { errorResponse, successResponse } from "../_shared/response.ts";
import { createAdminClient } from "../_shared/supabase.ts";

Deno.serve(async (req) => {
  const cors = handleCors(req);
  if (cors) return cors;

  if (req.method !== "POST") {
    return errorResponse("Método não permitido.", 405);
  }

  try {
    const { user_id: userId, otp_code: otpCode } = await req.json();

    if (!userId || !otpCode) {
      return errorResponse("Usuário e código são obrigatórios.");
    }

    const supabase = createAdminClient();
    const otpRecord = await validateOtp(supabase, userId, String(otpCode));

    if (!otpRecord) {
      return errorResponse("Código inválido ou expirado.");
    }

    const { error: updateError } = await supabase
      .from("users")
      .update({ status: true })
      .eq("id", userId);

    if (updateError) {
      console.error("[verify-otp] update error:", updateError);
      return errorResponse("Erro ao verificar conta.");
    }

    await clearOtp(supabase, userId);

    return successResponse("Conta verificada com sucesso!");
  } catch (error) {
    console.error("[verify-otp]", error);
    return errorResponse("Erro interno ao verificar código.", 500);
  }
});
