type EmailPurpose = "verify" | "recovery";

const subjects: Record<EmailPurpose, string> = {
  verify: "Confirme sua conta Poupix",
  recovery: "Redefina sua senha - Poupix",
};

const introLines: Record<EmailPurpose, string> = {
  verify: "Use o código abaixo para confirmar sua conta no Poupix:",
  recovery: "Use o código abaixo para redefinir sua senha no Poupix:",
};

const defaultSender = {
  name: Deno.env.get("BREVO_SENDER_NAME") ?? "SG Apps",
  email: Deno.env.get("BREVO_SENDER_EMAIL") ?? "no-reply@sgapps.org",
};

export async function sendOtpEmail(
  to: string,
  otp: string,
  purpose: EmailPurpose,
): Promise<void> {
  const apiKey = Deno.env.get("BREVO_API_KEY");

  if (!apiKey) {
    console.error(
      `[email] BREVO_API_KEY ausente. OTP ${purpose} para ${to}: ${otp}`,
    );
    throw new Error(
      "Serviço de e-mail não configurado. Contacte o suporte.",
    );
  }

  const response = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: {
      "api-key": apiKey,
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify({
      sender: defaultSender,
      to: [{ email: to }],
      subject: subjects[purpose],
      htmlContent: `
        <p>${introLines[purpose]}</p>
        <p style="font-size: 28px; font-weight: bold; letter-spacing: 4px;">${otp}</p>
        <p>Este código expira em 10 minutos.</p>
        <p>Se você não solicitou este código, ignore este e-mail.</p>
      `,
    }),
  });

  if (!response.ok) {
    const errorBody = await response.text();
    console.error("[email] Brevo error:", errorBody);
    throw new Error("Erro ao enviar e-mail. Tente novamente.");
  }
}
