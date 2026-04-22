#!/usr/bin/env python3
"""
Professional App Store Screenshot Generator for CitiZen
Uses Gemini API for AI-generated backgrounds + Pillow compositing.
Generates all 5 App Store screenshots with premium gradient backgrounds,
device frames, and bold typography.
"""

import os
import io
import math
from PIL import Image, ImageDraw, ImageFont, ImageChops, ImageFilter

# ── Try Gemini for background generation ───────────────────────────
GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
USE_GEMINI = False

try:
    from google import genai
    client = genai.Client(api_key=GEMINI_API_KEY)
    USE_GEMINI = True
    print("✓ Gemini API available — will generate AI backgrounds")
except Exception as e:
    print(f"⚠ Gemini not available ({e}), using gradient backgrounds")

# ── Canvas & Layout ────────────────────────────────────────────────
CANVAS_W = 1290
CANVAS_H = 2796

DEVICE_W = 1030
BEZEL = 15
SCREEN_W = DEVICE_W - 2 * BEZEL
SCREEN_CORNER_R = 62
DEVICE_CORNER_R = 77

DEVICE_X = (CANVAS_W - DEVICE_W) // 2
DEVICE_Y = 780

FONT_BOLD = "/Library/Fonts/SF-Pro-Display-Black.otf"
FONT_HEAVY = "/Library/Fonts/SF-Pro-Display-Heavy.otf"
FONT_MED = "/Library/Fonts/SF-Pro-Display-Medium.otf"

# Use Black for both if Heavy/Medium don't exist
for f in [FONT_HEAVY, FONT_MED]:
    if not os.path.exists(f):
        FONT_HEAVY = FONT_BOLD
        FONT_MED = FONT_BOLD

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCREENSHOTS_DIR = os.path.join(BASE_DIR, "screenshots")
ASSETS_DIR = os.path.join(BASE_DIR, "assets")
OUTPUT_DIR = os.path.join(SCREENSHOTS_DIR, "final")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# ── Screenshot configurations ──────────────────────────────────────
SCREENSHOTS = [
    {
        "id": "01",
        "verb": "PRACTICE",
        "desc": "THE REAL INTERVIEW",
        "screenshot": "IMG_5604.PNG",  # Mock interview with listening state
        "gradient": [(10, 30, 80), (20, 60, 140), (30, 90, 180)],
        "accent": (0, 180, 255),
        "gemini_prompt": "Abstract smooth gradient background, deep navy blue to royal blue, subtle American flag stars pattern faintly visible, elegant and modern, no text, 1290x2796 pixels",
    },
    {
        "id": "02",
        "verb": "STUDY",
        "desc": "IN YOUR LANGUAGE",
        "screenshot": "Simulator Screenshot - iPhone 17 Pro Max - 2026-04-11 at 21.09.45.png",  # Language selection
        "gradient": [(15, 40, 70), (25, 70, 120), (40, 100, 160)],
        "accent": (0, 200, 150),
        "gemini_prompt": "Abstract smooth gradient background, deep teal to dark blue, subtle globe/world pattern faintly visible, multilingual feel, elegant, no text, 1290x2796 pixels",
    },
    {
        "id": "03",
        "verb": "PASS",
        "desc": "WITH CONFIDENCE",
        "screenshot": "IMG_5605.PNG",  # PASSED results screen 8/10
        "gradient": [(10, 50, 30), (15, 80, 50), (20, 110, 70)],
        "accent": (0, 220, 100),
        "gemini_prompt": "Abstract smooth gradient background, deep emerald green to dark teal, subtle checkmark or success pattern, achievement feel, elegant, no text, 1290x2796 pixels",
    },
    {
        "id": "04",
        "verb": "KNOW",
        "desc": "WHEN YOU'RE READY",
        "screenshot": "Simulator Screenshot - iPhone 17 Pro Max - 2026-04-11 at 21.07.31.png",  # Practice selection
        "gradient": [(50, 20, 70), (80, 30, 110), (110, 40, 150)],
        "accent": (180, 100, 255),
        "gemini_prompt": "Abstract smooth gradient background, deep purple to indigo, subtle progress bar pattern, achievement feel, elegant, no text, 1290x2796 pixels",
    },
    {
        "id": "05",
        "verb": "300+",
        "desc": "OFFICIAL CIVICS QUESTIONS",
        "screenshot": "Simulator Screenshot - iPhone 17 Pro Max - 2026-04-11 at 21.09.56.png",  # Quiz question
        "gradient": [(60, 15, 15), (100, 25, 25), (140, 35, 35)],
        "accent": (255, 80, 80),
        "gemini_prompt": "Abstract smooth gradient background, deep crimson red to dark maroon, subtle American eagle or constitution pattern, patriotic feel, elegant, no text, 1290x2796 pixels",
    },
]


def create_gradient_bg(colors, canvas_w, canvas_h):
    """Create a smooth multi-stop vertical gradient background."""
    img = Image.new("RGB", (canvas_w, canvas_h))
    draw = ImageDraw.Draw(img)

    num_stops = len(colors)
    for y in range(canvas_h):
        # Find which two stops we're between
        t = y / canvas_h * (num_stops - 1)
        idx = min(int(t), num_stops - 2)
        frac = t - idx

        # Smooth easing
        frac = frac * frac * (3 - 2 * frac)

        c1 = colors[idx]
        c2 = colors[idx + 1]
        r = int(c1[0] + (c2[0] - c1[0]) * frac)
        g = int(c1[1] + (c2[1] - c1[1]) * frac)
        b = int(c1[2] + (c2[2] - c1[2]) * frac)
        draw.line([(0, y), (canvas_w, y)], fill=(r, g, b))

    # Add subtle radial glow in upper center
    glow = Image.new("RGBA", (canvas_w, canvas_h), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    cx, cy = canvas_w // 2, canvas_h // 4
    max_r = 600
    for r_i in range(max_r, 0, -3):
        alpha = int(25 * (1 - r_i / max_r) ** 2)
        glow_draw.ellipse(
            [cx - r_i, cy - r_i, cx + r_i, cy + r_i],
            fill=(255, 255, 255, alpha),
        )
    img = Image.alpha_composite(img.convert("RGBA"), glow).convert("RGB")

    return img


def generate_gemini_bg(prompt):
    """Try to generate a background using Gemini image generation."""
    if not USE_GEMINI:
        return None
    try:
        response = client.models.generate_images(
            model="imagen-3.0-generate-002",
            prompt=prompt,
            config=genai.types.GenerateImagesConfig(
                number_of_images=1,
                aspect_ratio="9:16",
            ),
        )
        if response.generated_images:
            img_bytes = response.generated_images[0].image.image_bytes
            img = Image.open(io.BytesIO(img_bytes)).convert("RGB")
            img = img.resize((CANVAS_W, CANVAS_H), Image.LANCZOS)
            return img
    except Exception as e:
        print(f"  ⚠ Gemini image gen failed: {e}")
    return None


def create_device_frame():
    """Create iPhone device frame (matching generate_frame.py)."""
    DEVICE_H = 2800
    DI_W, DI_H, DI_TOP = 130, 38, 14

    frame = Image.new("RGBA", (DEVICE_W, DEVICE_H), (0, 0, 0, 0))
    fd = ImageDraw.Draw(frame)

    # Device body
    fd.rounded_rectangle(
        [0, 0, DEVICE_W - 1, DEVICE_H - 1],
        radius=DEVICE_CORNER_R,
        fill=(30, 30, 30, 255),
    )
    fd.rounded_rectangle(
        [1, 1, DEVICE_W - 2, DEVICE_H - 2],
        radius=DEVICE_CORNER_R - 1,
        fill=(20, 20, 20, 255),
    )

    # Screen cutout
    cutout = Image.new("L", (DEVICE_W, DEVICE_H), 255)
    ImageDraw.Draw(cutout).rounded_rectangle(
        [BEZEL, BEZEL, BEZEL + SCREEN_W, BEZEL + DEVICE_H - 2 * BEZEL],
        radius=SCREEN_CORNER_R,
        fill=0,
    )
    frame.putalpha(ImageChops.multiply(frame.getchannel("A"), cutout))

    # Dynamic Island
    di_x = (DEVICE_W - DI_W) // 2
    di_y = BEZEL + DI_TOP
    ImageDraw.Draw(frame).rounded_rectangle(
        [di_x, di_y, di_x + DI_W, di_y + DI_H],
        radius=DI_H // 2,
        fill=(0, 0, 0, 255),
    )

    # Side buttons
    btn_color = (25, 25, 25, 255)
    fd2 = ImageDraw.Draw(frame)
    fd2.rounded_rectangle([DEVICE_W, 340, DEVICE_W + 4, 460], radius=2, fill=btn_color)
    fd2.rounded_rectangle([-4, 280, 0, 360], radius=2, fill=btn_color)
    fd2.rounded_rectangle([-4, 380, 0, 460], radius=2, fill=btn_color)
    fd2.rounded_rectangle([-4, 180, 0, 220], radius=2, fill=btn_color)

    return frame


def fit_font(text, font_path, max_w, size_max, size_min):
    """Return the largest font size where text fits within max_w."""
    dummy = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    for size in range(size_max, size_min - 1, -4):
        font = ImageFont.truetype(font_path, size)
        bbox = dummy.textbbox((0, 0), text, font=font)
        if (bbox[2] - bbox[0]) <= max_w:
            return font
    return ImageFont.truetype(font_path, size_min)


def draw_text_centered(draw, y, text, font, fill="white", shadow=True):
    """Draw centered text with optional drop shadow."""
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    x = (CANVAS_W - tw) // 2

    if shadow:
        # Subtle drop shadow
        draw.text((x + 3, y - bbox[1] + 3), text, fill=(0, 0, 0, 80), font=font)

    draw.text((x, y - bbox[1]), text, fill=fill, font=font)
    return y + th


def word_wrap_centered(draw, y, text, font, max_w, fill="white", shadow=True, line_gap=20):
    """Word wrap and draw centered text."""
    words = text.split()
    lines, cur = [], ""
    dummy = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    for w in words:
        test = f"{cur} {w}".strip()
        if dummy.textlength(test, font=font) <= max_w:
            cur = test
        else:
            if cur:
                lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)

    for line in lines:
        y = draw_text_centered(draw, y, line, font, fill=fill, shadow=shadow)
        y += line_gap

    return y


def compose_screenshot(config):
    """Compose a single App Store screenshot."""
    print(f"\n── Screenshot {config['id']}: {config['verb']} {config['desc']} ──")

    # 1. Background
    bg = None
    if USE_GEMINI:
        print("  Generating AI background with Gemini...")
        bg = generate_gemini_bg(config["gemini_prompt"])
        if bg:
            print("  ✓ AI background generated")

    if bg is None:
        print("  Creating gradient background...")
        bg = create_gradient_bg(config["gradient"], CANVAS_W, CANVAS_H)

    canvas = bg.convert("RGBA")
    draw = ImageDraw.Draw(canvas)

    # 2. Typography
    max_text_w = int(CANVAS_W * 0.90)

    # Verb (big bold)
    verb_font = fit_font(config["verb"], FONT_BOLD, max_text_w, 280, 150)
    y = 160
    y = draw_text_centered(draw, y, config["verb"], verb_font)
    y += 20

    # Description (slightly smaller, accent color or white)
    desc_font = fit_font(config["desc"], FONT_BOLD, max_text_w, 130, 80)
    accent = config.get("accent", (255, 255, 255))
    y = word_wrap_centered(draw, y, config["desc"], desc_font, max_text_w,
                           fill=accent, line_gap=24)

    # 3. Screenshot in device frame
    screenshot_path = os.path.join(SCREENSHOTS_DIR, config["screenshot"])
    shot = Image.open(screenshot_path).convert("RGBA")

    # Scale to fill screen width
    scale = SCREEN_W / shot.width
    sc_w = SCREEN_W
    sc_h = int(shot.height * scale)
    shot = shot.resize((sc_w, sc_h), Image.LANCZOS)

    screen_x = DEVICE_X + BEZEL
    screen_y = DEVICE_Y + BEZEL
    screen_h = CANVAS_H - screen_y + 500

    # Screen mask
    scr_mask = Image.new("L", canvas.size, 0)
    ImageDraw.Draw(scr_mask).rounded_rectangle(
        [screen_x, screen_y, screen_x + SCREEN_W, screen_y + screen_h],
        radius=SCREEN_CORNER_R,
        fill=255,
    )

    # Black screen bg + screenshot
    scr_layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(scr_layer).rounded_rectangle(
        [screen_x, screen_y, screen_x + SCREEN_W, screen_y + screen_h],
        radius=SCREEN_CORNER_R,
        fill=(0, 0, 0, 255),
    )
    scr_layer.paste(shot, (screen_x, screen_y))
    scr_layer.putalpha(scr_mask)
    canvas = Image.alpha_composite(canvas, scr_layer)

    # 4. Device frame
    frame = create_device_frame()
    frame_layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    frame_layer.paste(frame, (DEVICE_X, DEVICE_Y))
    canvas = Image.alpha_composite(canvas, frame_layer)

    # 5. Subtle bottom fade (vignette effect)
    vignette = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    vig_draw = ImageDraw.Draw(vignette)
    for i in range(200):
        alpha = int(40 * (i / 200) ** 2)
        vig_y = CANVAS_H - 200 + i
        vig_draw.line([(0, vig_y), (CANVAS_W, vig_y)], fill=(0, 0, 0, alpha))
    canvas = Image.alpha_composite(canvas, vignette)

    # 6. Save
    out_name = f"{config['id']}-{config['verb'].lower().replace('+', 'plus')}-{config['desc'].lower().replace(' ', '-').replace(\"'\", '')}.png"
    out_path = os.path.join(OUTPUT_DIR, out_name)
    canvas.convert("RGB").save(out_path, "PNG")
    print(f"  ✓ Saved: {out_path} ({CANVAS_W}×{CANVAS_H})")
    return out_path


def main():
    print("=" * 60)
    print("  CitiZen — App Store Screenshot Generator")
    print("=" * 60)

    generated = []
    for config in SCREENSHOTS:
        path = compose_screenshot(config)
        generated.append(path)

    print(f"\n{'=' * 60}")
    print(f"  ✓ Generated {len(generated)} screenshots in {OUTPUT_DIR}")
    print("=" * 60)

    # List output files
    for p in generated:
        print(f"  → {os.path.basename(p)}")


if __name__ == "__main__":
    main()
