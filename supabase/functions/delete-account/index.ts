import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { handleCors } from "../_shared/cors.ts";
import { errorResponse, successResponse } from "../_shared/response.ts";
import { createAdminClient, createAnonClient } from "../_shared/supabase.ts";

Deno.serve(async (req) => {
  const cors = handleCors(req);
  if (cors) return cors;

  if (req.method !== "POST") {
    return errorResponse("Método não permitido.", 405);
  }

  try {
    const {
      user_id: userId,
      email,
      password,
    } = await req.json();

    if (!userId || !email?.trim() || !password?.trim()) {
      return errorResponse("Dados insuficientes para excluir a conta.");
    }

    const normalizedEmail = email.trim().toLowerCase();
    const anonClient = createAnonClient();
    const adminClient = createAdminClient();

    const { data: profile, error: profileError } = await adminClient
      .from("users")
      .select("id, email")
      .eq("id", userId)
      .maybeSingle();

    if (profileError || !profile) {
      return errorResponse("Usuário não encontrado.");
    }

    if (profile.email?.toLowerCase() !== normalizedEmail) {
      return errorResponse("Dados de conta inválidos.");
    }

    const { error: signInError } = await anonClient.auth.signInWithPassword({
      email: normalizedEmail,
      password,
    });

    if (signInError) {
      return errorResponse("Senha incorreta.");
    }

    await adminClient.from("despesas").delete().eq("user_id", userId);
    await adminClient.from("categorias").delete().eq("user_id", userId);
    await adminClient.storage.from("profile").remove([
      `profile_${userId}.jpg`,
    ]);

    const { error: deleteAuthError } = await adminClient.auth.admin.deleteUser(
      userId,
    );

    if (deleteAuthError) {
      console.error("[delete-account] auth delete error:", deleteAuthError);
      return errorResponse("Erro ao excluir conta.");
    }

    return successResponse("Conta excluída com sucesso.");
  } catch (error) {
    console.error("[delete-account]", error);
    return errorResponse("Erro interno ao excluir conta.", 500);
  }
});
