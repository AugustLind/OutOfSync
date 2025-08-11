# Deployment Guide for Out of Sync Website

## 🚀 Quick Deploy Options

### 1. Render.com (Recommended - Free Tier Available)

**Steps:**
1. Push code to GitHub repository
2. Go to [render.com](https://render.com) and sign up
3. Click "New Web Service" and connect your GitHub repo
4. Select the `website` folder as root directory
5. Use these settings:
   - **Build Command**: `npm run build`
   - **Start Command**: `npm start`
   - **Environment**: `Node`
6. Click "Create Web Service"

**Your site will be live at**: `https://your-app-name.onrender.com`

---

### 2. Railway.app (Simple & Fast)

**Steps:**
1. Install Railway CLI: `npm install -g @railway/cli`
2. Login: `railway login`
3. Deploy from website folder:
   ```bash
   cd website
   railway init
   railway up
   ```

**Your site will be live at**: `https://your-app-name.up.railway.app`

---

### 3. Vercel + Railway (Split Frontend/Backend)

**Frontend on Vercel:**
```bash
cd client
npx vercel --prod
```

**Backend on Railway:**
```bash
cd server
railway init
railway up
```

Then update client environment to point to Railway backend URL.

---

### 4. Docker Deployment (VPS/Cloud)

**Build and run:**
```bash
cd website
docker build -t out-of-sync .
docker run -p 3001:3001 out-of-sync
```

---

## 🔧 Environment Variables

For production, set these environment variables:

```env
NODE_ENV=production
PORT=3001
FRONTEND_URL=https://your-frontend-domain.com
```

---

## 📋 Pre-deployment Checklist

- [ ] Test locally with `npm run dev`
- [ ] Build successfully with `npm run build`
- [ ] Push latest code to GitHub
- [ ] Set environment variables on hosting platform
- [ ] Test Socket.io connection after deployment

---

## 🌐 Custom Domain Setup

**After deployment:**
1. **Render**: Project Settings → Custom Domains → Add your domain
2. **Railway**: Project Settings → Domains → Add custom domain
3. **Vercel**: Project Settings → Domains → Add domain

**DNS Setup:**
- Add CNAME record pointing to your hosting platform
- Wait for DNS propagation (5-30 minutes)

---

## 🔍 Troubleshooting

**Common Issues:**

1. **Socket.io connection fails:**
   - Check CORS settings in server.js
   - Verify FRONTEND_URL environment variable

2. **Build fails:**
   - Ensure Node.js version compatibility (18+)
   - Check all dependencies are installed

3. **Images not loading:**
   - Celebrity images use external URLs (Wikipedia/placeholder)
   - Check CORS policies for image sources

**Debug Commands:**
```bash
# Check server logs
npm run server:dev

# Build client locally
cd client && npm run build

# Test production build
npm run build && npm start
```

---

## 💡 Performance Tips

- Images are loaded from CDN (placeholder.com, Wikipedia)
- Static files are served with compression
- Socket.io uses WebSocket transport for real-time updates
- Client-side routing with React Router

---

## 🔒 Security Notes

- CORS is configured for allowed origins
- No sensitive data stored client-side
- Game codes are randomly generated
- Sessions are managed in memory (restart clears games)