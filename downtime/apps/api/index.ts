import express from 'express';
import { authMiddleware } from './middleware';
import clerkClient from '@clerk/clerk-sdk-node';
import { prismaClient } from "../../packages/db/src";
import cors from 'cors';

// const prismaClient = new PrismaClient();


const  app = express();

app.use(cors({
    origin: ['http://localhost:3000', 'http://localhost:3003'],
    credentials: true
}));

app.use(express.json());

app.post("/api/v1/website", authMiddleware, async (req, res) => {
    const userId = req.userId!;
    const { url, name } = req.body;

    try {
        // First, ensure the user exists
        const user = await prismaClient.user.upsert({
            where: { id: userId },
            update: {},
            create: {
                id: userId,
                email: `${userId}@example.com` // We need an email since it's unique
            }
        });

        const data = await prismaClient.website.create({
            data: {
                url,
                name,
                userId: user.id
            }
        });

        res.json({
            id: data.id
        });
    } catch (error) {
        console.error('Error creating website:', error);
        res.status(500).json({ error: 'Failed to create website' });
    }
});

app.get("/api/v1/website/status", authMiddleware, async(req, res) =>{
    const websiteId = req.query.websiteId! as unknown as string;
    const userId = req.userId;

    const data = await prismaClient.website.findFirst({
        where : {
            id : websiteId,
            userId,
            disabled: false
        },
        include: {
            ticks: true
        },
        
    })

    res.json(data);
});


app.get("/api/v1/websites", authMiddleware, async (req, res) => {
    const userId = req.userId!;

    const websites = await prismaClient.website.findMany({
        where: {
            userId
        }, 
        include: {
            ticks: true
        }
    })

    res.json({
        websites
    });
})

app.delete("/api/v1/website/", authMiddleware, async (req, res) => {
    const websiteId = req.body.websiteId;
    const userId = req.userId!;

    await prismaClient.website.delete({
        where: {
            id: websiteId,
            userId
        }
    })

    res.json({
        message: "Deleted website successfully"
    })
})

app.listen(8080, () => {
    console.log('Server running on http://localhost:8080');
});