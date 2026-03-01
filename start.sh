#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "=============================="
echo "  TaskTracker — Production"
echo "=============================="

# Install backend dependencies
echo ""
echo "[1/4] Installing backend dependencies..."
(cd backend && npm install 2>&1 | tail -3)

# Install frontend dependencies
echo ""
echo "[2/4] Installing frontend dependencies..."
(cd frontend && npm install 2>&1 | tail -3)
chmod +x frontend/node_modules/.bin/* 2>/dev/null || true
chmod +x backend/node_modules/.bin/* 2>/dev/null || true

# Build frontend
echo ""
echo "[3/4] Building frontend..."
(cd frontend && npx tsc -b && npx vite build)

# Build backend
echo ""
echo "[4/4] Building backend..."
(cd backend && npx tsc)

# Start
echo ""
echo "=============================="
echo "  Starting server on port ${PORT:-3001}..."
echo "  Access at: http://$(hostname -I | awk '{print $1}'):${PORT:-3001}"
echo "=============================="
echo ""

cd backend && exec node dist/index.js
