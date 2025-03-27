/*
  Warnings:

  - You are about to drop the column `name` on the `Website` table. All the data in the column will be lost.
  - You are about to drop the `WebsiteTicks` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "WebsiteStatus" AS ENUM ('Good', 'Bad');

-- DropForeignKey
ALTER TABLE "Website" DROP CONSTRAINT "Website_userId_fkey";

-- DropForeignKey
ALTER TABLE "WebsiteTicks" DROP CONSTRAINT "WebsiteTicks_validatorId_fkey";

-- DropForeignKey
ALTER TABLE "WebsiteTicks" DROP CONSTRAINT "WebsiteTicks_websiteId_fkey";

-- DropIndex
DROP INDEX "User_email_key";

-- AlterTable
ALTER TABLE "Validator" ADD COLUMN     "pendingPayouts" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "Website" DROP COLUMN "name";

-- DropTable
DROP TABLE "WebsiteTicks";

-- DropEnum
DROP TYPE "WebsitesStatus";

-- CreateTable
CREATE TABLE "WebsiteTick" (
    "id" TEXT NOT NULL,
    "websiteId" TEXT NOT NULL,
    "validatorId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "status" "WebsiteStatus" NOT NULL,
    "latency" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "WebsiteTick_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "WebsiteTick" ADD CONSTRAINT "WebsiteTick_websiteId_fkey" FOREIGN KEY ("websiteId") REFERENCES "Website"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WebsiteTick" ADD CONSTRAINT "WebsiteTick_validatorId_fkey" FOREIGN KEY ("validatorId") REFERENCES "Validator"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
