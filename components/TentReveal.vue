<template>
  <div class="tr-root">
    <slot />
    <Transition name="tent-out">
      <div v-if="!open" class="tr-overlay-group" @click="openTent">
        <div class="tr-dark-cover" :style="{ opacity: coverOpacity }" />
        <canvas ref="canvasEl" class="tr-canvas" />
        <div class="tr-center-text" :style="{ opacity: textOpacity }">
          <div class="tr-title">Motoverse 2026</div>
          <div class="tr-hint">Tap to open</div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

const open = ref(false)
const canvasEl = ref<HTMLCanvasElement | null>(null)
const coverOpacity = ref(1)
const textOpacity = ref(1)

// Plain variables for animation state — avoids Vue re-render on every RAF tick
let _left = 0
let _right = 0
let _tgtL = 0
let _tgtR = 0
let _rafId: number | null = null
let _ro: ResizeObserver | null = null

function openTent() {
  _tgtL = 1
  _tgtR = 1
}

function resize() {
  const c = canvasEl.value
  if (!c) return
  const rect = c.getBoundingClientRect()
  const dpr = window.devicePixelRatio || 1
  c.width = rect.width * dpr
  c.height = rect.height * dpr
}

function drawLeftFlap(ctx: CanvasRenderingContext2D, cx: number, topY: number, bottomY: number, midL: number) {
  const p = _left
  if (p === 0) {
    ctx.fillStyle = '#557a46'
    ctx.beginPath()
    ctx.moveTo(cx, topY)
    ctx.lineTo(cx, bottomY)
    ctx.lineTo(midL, bottomY)
    ctx.closePath()
    ctx.fill()
    return
  }
  const destX = cx - (cx - midL) * p
  const destY = bottomY - (bottomY - topY) * 0.12 * p
  ctx.fillStyle = '#557a46'
  ctx.beginPath()
  ctx.moveTo(cx, topY)
  ctx.lineTo(midL, bottomY)
  ctx.lineTo(destX, destY)
  ctx.quadraticCurveTo(cx - (cx - midL) * p * 0.4, topY + (bottomY - topY) * 0.5, cx, topY)
  ctx.closePath()
  ctx.fill()
  ctx.fillStyle = '#dca631'
  ctx.beginPath()
  ctx.moveTo(destX, destY)
  ctx.lineTo(destX + 16 * p, destY - 8 * p)
  ctx.quadraticCurveTo(cx - (cx - midL) * p * 0.35, topY + (bottomY - topY) * 0.52, cx, topY)
  ctx.quadraticCurveTo(cx - (cx - midL) * p * 0.4, topY + (bottomY - topY) * 0.5, destX, destY)
  ctx.closePath()
  ctx.fill()
}

function drawRightFlap(ctx: CanvasRenderingContext2D, cx: number, topY: number, bottomY: number, midR: number) {
  const p = _right
  if (p === 0) {
    ctx.fillStyle = '#3f5d34'
    ctx.beginPath()
    ctx.moveTo(cx, topY)
    ctx.lineTo(cx, bottomY)
    ctx.lineTo(midR, bottomY)
    ctx.closePath()
    ctx.fill()
    return
  }
  const destX = cx + (midR - cx) * p
  const destY = bottomY - (bottomY - topY) * 0.12 * p
  ctx.fillStyle = '#3f5d34'
  ctx.beginPath()
  ctx.moveTo(cx, topY)
  ctx.lineTo(midR, bottomY)
  ctx.lineTo(destX, destY)
  ctx.quadraticCurveTo(cx + (midR - cx) * p * 0.4, topY + (bottomY - topY) * 0.5, cx, topY)
  ctx.closePath()
  ctx.fill()
  ctx.fillStyle = '#be8c21'
  ctx.beginPath()
  ctx.moveTo(destX, destY)
  ctx.lineTo(destX - 16 * p, destY - 8 * p)
  ctx.quadraticCurveTo(cx + (midR - cx) * p * 0.35, topY + (bottomY - topY) * 0.52, cx, topY)
  ctx.quadraticCurveTo(cx + (midR - cx) * p * 0.4, topY + (bottomY - topY) * 0.5, destX, destY)
  ctx.closePath()
  ctx.fill()
}

function render() {
  const c = canvasEl.value
  if (!c) { _rafId = requestAnimationFrame(render); return }
  const ctx = c.getContext('2d')
  if (!ctx) { _rafId = requestAnimationFrame(render); return }

  // Spring interpolation
  _left += (_tgtL - _left) * 0.1
  _right += (_tgtR - _right) * 0.1

  // Update reactive values for CSS bindings (cheap compared to canvas draw)
  const progress = (_left + _right) / 2
  coverOpacity.value = Math.max(0, 1 - progress)
  textOpacity.value = Math.max(0, 1 - progress * 3)

  if (_left > 0.97 && _right > 0.97 && _tgtL === 1 && _tgtR === 1) {
    open.value = true
    return
  }

  const dpr = window.devicePixelRatio || 1
  const w = c.width / dpr
  const h = c.height / dpr
  const cx = w / 2

  ctx.save()
  ctx.scale(dpr, dpr)
  ctx.clearRect(0, 0, w, h)

  const topY = h * 0.07
  const bottomY = h * 0.93
  const halfW = w * 0.44
  const leftBase = cx - halfW
  const rightBase = cx + halfW
  const midL = cx - halfW * 0.82
  const midR = cx + halfW * 0.82

  // Ground strip
  ctx.fillStyle = '#7a3e18'
  ctx.beginPath()
  ctx.moveTo(leftBase - 10, bottomY)
  ctx.lineTo(rightBase + 10, bottomY)
  ctx.lineTo(rightBase + 24, bottomY + h * 0.06)
  ctx.lineTo(leftBase - 24, bottomY + h * 0.06)
  ctx.closePath()
  ctx.fill()

  // Dark inner ceiling (between outer walls)
  ctx.fillStyle = '#0e1c0c'
  ctx.beginPath()
  ctx.moveTo(cx, topY)
  ctx.lineTo(leftBase, bottomY)
  ctx.lineTo(rightBase, bottomY)
  ctx.closePath()
  ctx.fill()

  // Left outer structural wall
  ctx.fillStyle = '#3a5830'
  ctx.beginPath()
  ctx.moveTo(cx, topY)
  ctx.lineTo(leftBase, bottomY)
  ctx.lineTo(midL, bottomY)
  ctx.closePath()
  ctx.fill()

  // Right outer structural wall
  ctx.fillStyle = '#2f4a27'
  ctx.beginPath()
  ctx.moveTo(cx, topY)
  ctx.lineTo(rightBase, bottomY)
  ctx.lineTo(midR, bottomY)
  ctx.closePath()
  ctx.fill()

  // Left and right flaps (animate open)
  drawLeftFlap(ctx, cx, topY, bottomY, midL)
  drawRightFlap(ctx, cx, topY, bottomY, midR)

  // Zipper line down center (visible until fully open)
  if (_left < 0.94 || _right < 0.94) {
    const zipStart = topY + (bottomY - topY) * Math.max(_left, _right)
    ctx.strokeStyle = '#64748b'
    ctx.lineWidth = 2.5
    ctx.setLineDash([6, 5])
    ctx.beginPath()
    ctx.moveTo(cx, zipStart)
    ctx.lineTo(cx, bottomY)
    ctx.stroke()
    ctx.setLineDash([])
  }

  // Ridge cap at peak
  ctx.fillStyle = '#1e2e1a'
  ctx.beginPath()
  ctx.moveTo(cx - 20, topY + 10)
  ctx.lineTo(cx, topY - 8)
  ctx.lineTo(cx + 20, topY + 10)
  ctx.closePath()
  ctx.fill()
  ctx.strokeStyle = '#4a7a3a'
  ctx.lineWidth = 1.5
  ctx.stroke()

  ctx.restore()
  _rafId = requestAnimationFrame(render)
}

onMounted(() => {
  resize()
  const c = canvasEl.value
  if (c) {
    _ro = new ResizeObserver(resize)
    _ro.observe(c)
  }
  _rafId = requestAnimationFrame(render)
})

onBeforeUnmount(() => {
  if (_rafId) cancelAnimationFrame(_rafId)
  if (_ro) _ro.disconnect()
})
</script>

<style scoped>
.tr-root {
  position: relative;
  width: 100%;
  height: 100%;
}

.tr-overlay-group {
  position: absolute;
  inset: 0;
  z-index: 10;
  border-radius: 0.75rem;
  overflow: hidden;
  cursor: pointer;
}

.tr-dark-cover {
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at 50% 28%, #0b1c38 0%, #030b14 100%);
  pointer-events: none;
}

.tr-canvas {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.tr-center-text {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
  pointer-events: none;
}

.tr-title {
  font-size: 22px;
  font-weight: 900;
  color: #ffffff;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  text-shadow: 0 0 24px rgba(217, 119, 6, 0.55), 0 2px 8px rgba(0,0,0,0.6);
}

.tr-hint {
  font-size: 10px;
  color: #d97706;
  letter-spacing: 0.35em;
  text-transform: uppercase;
  font-weight: 600;
  animation: trpulse 2s ease-in-out infinite;
}

/* Leave transition: whole group fades out after tent is fully open */
.tent-out-leave-active {
  transition: opacity 0.35s ease;
}
.tent-out-leave-to {
  opacity: 0;
}

@keyframes trpulse {
  0%, 100% { opacity: 0.4; }
  50% { opacity: 1; }
}
</style>
