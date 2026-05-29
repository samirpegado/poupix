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
    const { email, otp_code: otpCode, new_password: newPassword } =
      await req.json();

    if (!email?.trim() || !otpCode || !newPassword?.trim()) {
      return errorResponse("E-mail, código e nova senha são obrigatórios.");
    }

    if (String(newPassword).length < 6) {
      return errorResponse("A senha deve ter pelo menos 6 caracteres.");
    }

    const normalizedEmail = email.trim().toLowerCase();
    const supabase = createAdminClient();

    const { data: user, error: userError } = await supabase
      .from("users")
      .select("id")
      .eq("email", normalizedEmail)
      .maybeSingle();

    if (userError || !user?.id) {
      return errorResponse("Usuário não encontrado.");
    }

    const otpRecord = await validateOtp(supabase, user.id, String(otpCode));

    if (!otpRecord) {
      return errorResponse("Código inválido ou expirado.");
    }

    const { error: passwordError } = await supabase.auth.admin.updateUserById(
      user.id,
      { password: newPassword },
    );

    if (passwordError) {
      console.error("[reset-password-mobile] password error:", passwordError);
      return errorResponse("Erro ao redefinir senha.");
    }

    await clearOtp(supabase, user.id);

    return successResponse("Senha redefinida com sucesso!");
  } catch (error) {
    console.error("[reset-password-mobile]", error);
    return errorResponse("Erro interno ao redefinir senha.", 500);
  }
});
