import QtQuick

// Selbst erzeugtes Hintergrundbild: dunkler Grund, weiche Farbflächen, ruhige Geometrie.
// Wird einmal gezeichnet und kostet danach nichts mehr.
Canvas {
    id: wp

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function blob(ctx, cx, cy, r, rgb, alpha) {
        var g = ctx.createRadialGradient(cx, cy, 0, cx, cy, r)
        g.addColorStop(0.0, "rgba(" + rgb + "," + alpha + ")")
        g.addColorStop(0.55, "rgba(" + rgb + "," + (alpha * 0.42) + ")")
        g.addColorStop(1.0, "rgba(" + rgb + ",0)")
        ctx.fillStyle = g
        ctx.fillRect(cx - r, cy - r, r * 2, r * 2)
    }

    function disc(ctx, cx, cy, r, rgbA, aA, rgbB, aB) {
        var g = ctx.createLinearGradient(cx - r, cy - r, cx + r, cy + r)
        g.addColorStop(0, "rgba(" + rgbA + "," + aA + ")")
        g.addColorStop(1, "rgba(" + rgbB + "," + aB + ")")
        ctx.fillStyle = g
        ctx.beginPath()
        ctx.arc(cx, cy, r, 0, Math.PI * 2)
        ctx.fill()
    }

    function ring(ctx, cx, cy, r, w, rgb, alpha) {
        ctx.strokeStyle = "rgba(" + rgb + "," + alpha + ")"
        ctx.lineWidth = w
        ctx.beginPath()
        ctx.arc(cx, cy, r, 0, Math.PI * 2)
        ctx.stroke()
    }

    function tile(ctx, cx, cy, s, rot, rgbA, aA, rgbB, aB) {
        ctx.save()
        ctx.translate(cx, cy)
        ctx.rotate(rot)
        var g = ctx.createLinearGradient(-s / 2, -s / 2, s / 2, s / 2)
        g.addColorStop(0, "rgba(" + rgbA + "," + aA + ")")
        g.addColorStop(1, "rgba(" + rgbB + "," + aB + ")")
        ctx.fillStyle = g
        ctx.beginPath()
        ctx.roundedRect(-s / 2, -s / 2, s, s, s * 0.24, s * 0.24)
        ctx.fill()
        ctx.restore()
    }

    onPaint: {
        var ctx = getContext("2d")
        var w = width, h = height
        if (w <= 0 || h <= 0)
            return
        var u = Math.max(w, h)

        // Grund
        var base = ctx.createLinearGradient(0, 0, w, h)
        base.addColorStop(0, "#0c0c12")
        base.addColorStop(1, "#13111a")
        ctx.fillStyle = base
        ctx.fillRect(0, 0, w, h)

        // Weiche Farbflächen
        blob(ctx, w * 0.16, h * 0.86, u * 0.52, "132,26,34", 0.62)
        blob(ctx, w * 0.86, h * 0.14, u * 0.50, "30,72,150", 0.52)
        blob(ctx, w * 0.56, h * 0.52, u * 0.42, "84,46,140", 0.34)
        blob(ctx, w * 0.06, h * 0.10, u * 0.34, "16,104,108", 0.36)
        blob(ctx, w * 0.94, h * 0.92, u * 0.36, "150,82,30", 0.26)

        // Geometrie
        disc(ctx, w * 0.20, h * 0.78, u * 0.19, "214,70,74", 0.34, "120,22,30", 0.05)
        disc(ctx, w * 0.79, h * 0.25, u * 0.13, "96,150,240", 0.30, "40,60,150", 0.04)
        tile(ctx, w * 0.67, h * 0.64, u * 0.17, -0.32, "150,104,232", 0.24, "60,34,120", 0.04)
        tile(ctx, w * 0.33, h * 0.27, u * 0.10, 0.42, "44,176,172", 0.22, "12,70,84", 0.03)
        disc(ctx, w * 0.90, h * 0.70, u * 0.055, "240,170,96", 0.26, "150,82,30", 0.04)
        disc(ctx, w * 0.47, h * 0.84, u * 0.035, "255,255,255", 0.12, "255,255,255", 0.02)
        ring(ctx, w * 0.79, h * 0.25, u * 0.175, 1.5, "255,255,255", 0.10)
        ring(ctx, w * 0.20, h * 0.78, u * 0.245, 1.5, "255,255,255", 0.07)
        ring(ctx, w * 0.50, h * 0.36, u * 0.070, 10, "255,255,255", 0.045)

        // Ränder leicht abdunkeln
        var v = ctx.createRadialGradient(w / 2, h / 2, u * 0.25, w / 2, h / 2, u * 0.78)
        v.addColorStop(0, "rgba(0,0,0,0)")
        v.addColorStop(1, "rgba(0,0,0,0.42)")
        ctx.fillStyle = v
        ctx.fillRect(0, 0, w, h)
    }
}
