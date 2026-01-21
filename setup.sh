#!/bin/bash

# BaseCast Markets Development Setup Script
echo "🚀 Setting up BaseCast Markets development environment..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d"." -f1 | cut -d"v" -f2)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm."
    exit 1
fi

# Install dependencies
echo "📦 Installing contract dependencies..."
cd contracts && npm install
cd ..

echo "📦 Installing frontend dependencies..."
cd frontend && npm install
cd ..

# Copy environment template if .env doesn't exist
if [ ! -f contracts/.env ]; then
    echo "📋 Setting up #!/bin/bash

# BaseCast Markets Development Setup Sco
# BaseCasnv
echo "🚀 Setting up BaseCast Markets devfr
# Checkate. Please fill in your values."
fi

echo "🎉 Setup complif ! command -v node &> /dev/ncommands:"
echo "  make help            -     echo "   Visit: https://nodejs.org/"
    exit 1
fi

# Check Node.js vep    exit 1
fi

# Check Node.js version
lefi

# Chee 
marNODE_VERSION=$(node -vakif [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Nodero    echo "❌ Node.js version 18+ lo    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/nulo fi

# Cheps
"
eif ! command -v npm &> /deac    echo "❌ npm is not installed. Pd     exit 1
fi

# Inun 'make contracts-compile' to compilefi

# Insracts"echo "📦 Installingrocd contracts && npm install
cd ..

echo "📦 hocd ..

echo "📦 ocalhost:3
echin cd frontend && npm install
cd ..

# Copy envirdecd ..

# Copy environmentr-
# Cose up basecast-dev"
