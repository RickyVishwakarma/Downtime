import { prisma } from '@/lib/prisma';

export function usePrisma() {
  return prisma;
} 