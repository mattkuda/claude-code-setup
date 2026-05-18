# Scaffold New App

Create a new full-stack application skeleton with the following structure and technologies.

## Tech Stack

- **Framework:** Next.js 15+ (App Router, React 19, TypeScript 5)
- **Styling:** Tailwind CSS 4, Shadcn/ui (new-york style)
- **Backend:** Supabase (PostgreSQL database, Auth)
- **Package Manager:** npm

## Project Structure

Create the following directory structure:

```
$ARGUMENTS/
├── .claude/
│   └── commands/           # Custom Claude slash commands
├── docs/
│   ├── tasks/
│   │   ├── todo/           # Tasks not yet started
│   │   ├── doing/          # Tasks in progress
│   │   └── done/           # Completed tasks
│   ├── architecture.md     # System architecture decisions
│   └── api.md              # API documentation
├── src/
│   ├── app/
│   │   ├── (auth)/         # Auth routes (login, signup, etc.)
│   │   ├── (dashboard)/    # Protected dashboard routes
│   │   ├── api/            # API routes
│   │   ├── globals.css     # Global styles with CSS variables
│   │   ├── layout.tsx      # Root layout
│   │   └── page.tsx        # Landing page
│   ├── components/
│   │   ├── ui/             # Shadcn/ui components
│   │   └── layout/         # Layout components (sidebar, header, nav)
│   ├── lib/
│   │   ├── supabase/
│   │   │   ├── client.ts   # Browser Supabase client
│   │   │   ├── server.ts   # Server Supabase client
│   │   │   └── middleware.ts
│   │   ├── utils.ts        # Utility functions (cn helper)
│   │   └── constants.ts    # App constants and mock data
│   ├── hooks/              # Custom React hooks
│   ├── types/
│   │   └── database.ts     # Supabase generated types
│   └── middleware.ts       # Next.js middleware for auth
├── supabase/
│   ├── migrations/         # Database migrations
│   └── seed.sql            # Seed data
├── public/                 # Static assets
├── .env.local.example      # Environment variable template
├── .gitignore
├── CLAUDE.md               # Claude Code instructions
├── README.md
├── components.json         # Shadcn/ui config
├── next.config.ts
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```

## Files to Generate

### 1. CLAUDE.md

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

[PROJECT_NAME] is a Next.js full-stack web application using Supabase for authentication and database.

## Commands

\`\`\`bash
npm run dev      # Start development server (http://localhost:3000)
npm run build    # Production build
npm run start    # Start production server
npm run lint     # Run ESLint
\`\`\`

## Architecture

### Tech Stack
- **Framework:** Next.js 15+ with App Router, React 19, TypeScript 5
- **Styling:** Tailwind CSS 4, Shadcn/ui (new-york style), Radix UI
- **Backend:** Supabase (PostgreSQL, Auth)

### Route Groups
- `/(auth)` - Login/signup pages with centered layout
- `/(dashboard)` - Protected routes with sidebar navigation

### Key Directories
- `/src/components/ui` - Shadcn/ui component library
- `/src/components/layout` - Sidebar, header, mobile navigation
- `/src/lib/supabase` - Server and client Supabase helpers
- `/src/types/database.ts` - Supabase TypeScript types

### Task Management
Tasks are tracked in `/docs/tasks/`:
- `todo/` - Tasks to be started (create new .md files here)
- `doing/` - Tasks in progress (move files here when starting)
- `done/` - Completed tasks (move files here when finished)

Each task file should include: title, description, acceptance criteria, and notes.

### Debug Mode
Set `NEXT_PUBLIC_DEBUG_MODE=true` to bypass Supabase auth and use mock data from `/src/lib/constants.ts`.

### Path Aliases
`@/*` maps to `./src/*`

## Design System

Theme variables defined in `/src/app/globals.css`. Dark mode supported via CSS variables.

## Environment Variables

Required in `.env.local`:
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anon key
- `SUPABASE_SERVICE_ROLE_KEY` - Supabase service role key (server only)
- `NEXT_PUBLIC_APP_URL` - Application URL
- `NEXT_PUBLIC_DEBUG_MODE` - Enable debug/mock mode

## Database

Run migrations: `npx supabase db push`
Generate types: `npx supabase gen types typescript --local > src/types/database.ts`
```

### 2. .env.local.example

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_DEBUG_MODE=false
```

### 3. src/lib/supabase/client.ts

```typescript
import { createBrowserClient } from '@supabase/ssr'
import type { Database } from '@/types/database'

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### 4. src/lib/supabase/server.ts

```typescript
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import type { Database } from '@/types/database'

export async function createClient() {
  const cookieStore = await cookies()

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // Called from Server Component
          }
        },
      },
    }
  )
}
```

### 5. src/lib/utils.ts

```typescript
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

### 6. src/middleware.ts

```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()

  // Protect dashboard routes
  if (request.nextUrl.pathname.startsWith('/dashboard') && !user) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'],
}
```

### 7. Sample Task File (docs/tasks/todo/example-task.md)

```markdown
# Task: Example Task Title

## Description
Brief description of what needs to be done.

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Notes
Any additional context or implementation notes.

## Related Files
- `src/path/to/file.ts`
```

## Setup Commands

After generating the skeleton, run:

```bash
cd $ARGUMENTS
npm install
npx shadcn@latest init -y
npx shadcn@latest add button card input label
```

## Dependencies to Install

```json
{
  "dependencies": {
    "next": "latest",
    "react": "^19",
    "react-dom": "^19",
    "@supabase/supabase-js": "latest",
    "@supabase/ssr": "latest",
    "clsx": "latest",
    "tailwind-merge": "latest"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "latest",
    "@types/react": "latest",
    "@types/react-dom": "latest",
    "tailwindcss": "^4",
    "eslint": "latest",
    "eslint-config-next": "latest"
  }
}
```

## Instructions

1. Create the directory structure as specified above
2. Generate all configuration files (package.json, tsconfig.json, next.config.ts, tailwind.config.ts, components.json)
3. Create all the source files listed
4. Set up the Supabase client helpers
5. Create the middleware for auth protection
6. Add placeholder pages for auth and dashboard routes
7. Initialize shadcn/ui with the new-york style
8. Create a basic landing page

The project name/directory should be: $ARGUMENTS
