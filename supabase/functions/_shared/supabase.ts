import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js@2";

export function createAdminClient(): SupabaseClient {
  const url = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!url || !serviceRoleKey) {
    throw new Error("Supabase admin credentials are not configured.");
  }

  return createClient(url, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

export function createAnonClient(): SupabaseClient {
  const url = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");

  if (!url || !anonKey) {
    throw new Error("Supabase anon credentials are not configured.");
  }

  return createClient(url, anonKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
