import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { handleCors } from "../_shared/cors.ts";
import { errorResponse, successResponse } from "../_shared/response.ts";
import { createAdminClient } from "../_shared/supabase.ts";

Deno.serve(async (req) => {
  const cors = handleCors(req);
  if (cors) return cors;

  if (req.method !== "POST") {
    return errorResponse("Método não permitido.", 405);
  }

  try {
    const { nome, email, password, cpf, celular } = await req.json();

    if (!nome?.trim() || !email?.trim() || !password?.trim()) {
      return errorResponse("Nome, e-mail e senha são obrigatórios.");
    }

    const supabase = createAdminClient();

    const { data: authData, error: authError } = await supabase.auth.admin
      .createUser({
        email: email.trim().toLowerCase(),
        password,
        email_confirm: true,
      });

    if (authError) {
      const message = authError.message.toLowerCase().includes("already")
        ? "Este e-mail já está cadastrado."
        : authError.message;
      return errorResponse(message);
    }

    const userId = authData.user!.id;

    const { error: profileError } = await supabase.from("users").insert({
      id: userId,
      email: email.trim().toLowerCase(),
      nome: nome.trim(),
      cpf: cpf?.trim() || null,
      celular: celular?.trim() || null,
      status: false,
    });

    if (profileError) {
      await supabase.auth.admin.deleteUser(userId);
      console.error("[create-account] profile error:", profileError);
      return errorResponse("Erro ao criar perfil do usuário.");
    }

    return successResponse("Conta criada com sucesso! Faça login para continuar.");
  } catch (error) {
    console.error("[create-account]", error);
    return errorResponse("Erro interno ao criar conta.", 500);
  }
});
