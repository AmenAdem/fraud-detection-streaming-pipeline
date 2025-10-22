const users = ['alice', 'bob', 'charlie', 'dave', 'eve', 'john'];
const suspiciousUsers = ['fraud_attempt', 'suspicious_user'];

function pick<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

export function randomTransaction() {
  const now = new Date();

  // 15% chance to generate a suspicious user
  const isSuspiciousUser = Math.random() < 0.15;
  const user = isSuspiciousUser ? pick(suspiciousUsers) : pick(users);

  // Skew amounts: many small, some medium, a few large
  let amount: number;
  const r = Math.random();
  if (r < 0.7) amount = Math.floor(Math.random() * 200) + 1; // 1..200
  else if (r < 0.9) amount = Math.floor(Math.random() * 2000) + 200; // 200..2200
  else amount = Math.floor(Math.random() * 20000) + 2000; // 2000..22000

  // 5% chance to set exactly 10000 to trip the string rule
  if (Math.random() < 0.05) amount = 10000;

  const tx = {
    id: `tx_${now.getTime()}_${Math.floor(Math.random() * 1000)}`,
    amount,
    user,
    timestamp: now.toISOString(),
  } as Record<string, any>;

  // 5% chance to add a message with the word 'fraud' to trip the rule
  if (Math.random() < 0.05) {
    tx.note = 'potential fraud pattern observed';
  }

  return tx;
}

