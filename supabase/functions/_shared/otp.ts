import { SupabaseClient } from "jsr:@supabase/supabase-js@2";

const OTP_TTL_MINUTES = 10;

export function generateOtp(): string {
  return String(Math.floor(1000 + Math.random() * 9000));
}

export async function storeOtp(
  supabase: SupabaseClient,
  userId: string,
  otp: string,
): Promise<void> {
  const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60 * 1000)
    .toISOString();

  const { error } = await supabase.from("email_otps").upsert({
    user_id: userId,
    otp_code: otp,
    expires_at: expiresAt,
  });

  if (error) {
    throw error;
  }
}

export async function validateOtp(
  supabase: SupabaseClient,
  userId: string,
  otpCode: string,
) {
  const { data, error } = await supabase
    .from("email_otps")
    .select("*")
    .eq("user_id", userId)
    .eq("otp_code", otpCode)
    .gt("expires_at", new Date().toISOString())
    .maybeSingle();

  if (error) {
    throw error;
  }

  return data;
}

export async function clearOtp(
  supabase: SupabaseClient,
  userId: string,
): Promise<void> {
  await supabase.from("email_otps").delete().eq("user_id", userId);
}
