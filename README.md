# Motoverse 2026 — Digital Stall Presentation

Interactive Slidev presentation for Royal Enfield Motoverse 2026, built by the Navigation & Connected Tech team.

---

## Prerequisites

- **Node.js** v18 or higher — [Download](https://nodejs.org/)
- **npm** v9 or higher (bundled with Node.js)

Verify your installation:

```bash
node --version
npm --version
```

---

## Setup & Run

### Option A — Double-click (Windows)

1. Clone or download this repository
2. Double-click **`start-server.bat`**
3. First run automatically installs all packages, then starts the server

### Option B — Manual (any OS / terminal)

```bash
# 1. Install dependencies
npm install

# 2. Start the presentation server (LAN accessible)
npm run host
```

Open your browser to: **http://localhost:3030**

For LAN access (presenting on another device on the same network):  
**http://\<your-ip\>:3030**

---

## Available Commands

| Command | Description |
|---|---|
| `npm run host` | Start server on LAN — port 3030 (use this for presenting) |
| `npm run dev` | Start dev server with hot-reload (use this while editing) |
| `npm run build` | Build static output to `dist/` |
| `npm run export` | Export slides to PDF |

---

## Presentation Structure

| Zone | Content |
|---|---|
| **Intro** | Cover, stall overview, RE digital ecosystem map |
| **Zone 1 · The Connected Garage** | Wingman Persona analyzer, GRID Support live feed |
| **Zone 2 · The Navigation Lab** | RElive 3D route replay, Motoverse Navigator, Tripper Education hub |
| **Zone 3 · The Future Lounge** | K1G/L1A Cluster UX, Product Roadmap canvas, Digital Stall Command |
| **Closing** | Motoverse Grid India map, event summary |

---

## Interactive HTML Demos (`public/projects/`)

| File | Description |
|---|---|
| `wingman.html` | Wingman ride persona analyzer |
| `grid_support.html` | GRID RSA live support feed |
| `re_digital_stall_command.html` | 3-day stall command & touchpoint hub |
| `relive-clone.html` | RElive 3D route replay (Google Maps) |
| `motoverse_navigator.html` | Motoverse Navigator — walk-to-vehicle demo |
| `stall_canvas.html` | Interactive product roadmap swimlane |
| `cluster_ux.html` | K1G / L1A cluster UX preview |
| `indiamap.html` | Motoverse Grid — India routes physics map |

> All heavy demos use a **click-to-load splash screen** to prevent browser memory issues during slide pre-rendering.

---

## Tech Stack

- [Slidev](https://sli.dev/) v52 — markdown presentation framework
- [Vue 3](https://vuejs.org/) — component rendering
- [Tailwind CSS](https://tailwindcss.com/) — utility styling (via CDN inside HTML demos)
- Vanilla JS + Canvas API — interactive demo files

---

## Troubleshooting

**Port 3030 already in use**
```bash
npx kill-port 3030
npm run host
```

**Browser crash / out of memory on iframe slides**
- Each heavy demo has a splash screen — click it to load
- Avoid navigating through iframe slides too quickly

**Slides not updating**
- Use `npm run dev` while editing (live hot-reload)
- Always use `npm run host` for the final presentation
