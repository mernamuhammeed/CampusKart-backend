---
name: Autonomous Campus Mobility
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#bbcabf'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#86948a'
  outline-variant: '#3c4a42'
  surface-tint: '#4edea3'
  primary: '#4edea3'
  on-primary: '#003824'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#006c49'
  secondary: '#ffb95f'
  on-secondary: '#472a00'
  secondary-container: '#ee9800'
  on-secondary-container: '#5b3800'
  tertiary: '#ffb3ad'
  on-tertiary: '#68000a'
  tertiary-container: '#ff7a73'
  on-tertiary-container: '#79000e'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#ffddb8'
  secondary-fixed-dim: '#ffb95f'
  on-secondary-fixed: '#2a1700'
  on-secondary-fixed-variant: '#653e00'
  tertiary-fixed: '#ffdad7'
  tertiary-fixed-dim: '#ffb3ad'
  on-tertiary-fixed: '#410004'
  on-tertiary-fixed-variant: '#930013'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  headline-xl:
    fontFamily: Outfit
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Outfit
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Outfit
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Outfit
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Outfit
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Outfit
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Outfit
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Outfit
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-padding: 20px
  stack-gap: 12px
  section-margin: 24px
  touch-target: 48px
  bottom-sheet-peak: 280px
---

## Brand & Style
The design system focuses on a premium, frictionless experience for autonomous campus travel. The brand personality is forward-thinking, reliable, and technologically advanced, catering to a fast-paced university environment. 

The visual style is **Modern Corporate with Glassmorphic accents**. It leverages high-transparency layers, backdrop blurs, and soft micro-shadows to create a sense of depth and hierarchy without feeling heavy. The aesthetic is intentionally spacious and airy, using wide margins and large radii to evoke the clean, silent nature of electric autonomous vehicles. Interaction is characterized by smooth transitions and a dynamic feel that mirrors the fluid movement of the golf carts across campus.

## Colors
The palette is built around an "Emerald Mint" primary color that signifies movement and green energy. 

In the **Light Theme**, surfaces are pure white against a soft porcelain background to maintain high legibility. 
In the **Dark Theme**, the "Obsidian Midnight" background provides a high-tech backdrop for "Deep Charcoal" glassmorphic surfaces. 

Functional colors for Pickup and Dropoff are tuned for visibility: 
- **Pickup** uses warm Amber tones to signify anticipation and "wait/arrive" states.
- **Dropoff** uses Coral tones for clarity and destination markers.
- **Action/Success** uses the Emerald Mint for buttons, active routes, and "Ready" statuses.

## Typography
This design system uses **Outfit** for its geometric yet approachable character. The typeface strikes a perfect balance between technical precision (fitting for an autonomous vehicle app) and friendly campus utility.

Headlines use heavy weights and slight negative letter-spacing to command attention on navigation headers and ETAs. Body text remains clean with standard tracking for high readability during outdoor use. Labels are set in medium or semi-bold weights to ensure they stand out against translucent glassmorphic backgrounds.

## Layout & Spacing
The layout follows a **fluid-to-safe-area** model. Elements are largely grouped into floating containers rather than edge-to-edge blocks to emphasize the glassmorphic depth.

- **Margins**: Use a 20px safety margin on mobile devices.
- **Gutters**: A standard 12px vertical gap is used between cards and list items.
- **Safe Areas**: Ensure all primary interactive elements (like the "Request Ride" button) stay within the bottom 33% of the screen for ergonomic thumb-access.
- **Grid**: Use an 8px base grid for all padding and alignment.

## Elevation & Depth
Depth is the core differentiator of this design system. It is achieved through two primary techniques:

1.  **Glassmorphism**: Primary surfaces (Bottom Sheets, Floating Cards) use a semi-transparent fill with a `backdrop-filter: blur(12px)`. In light mode, use `rgba(255, 255, 255, 0.7)`; in dark mode, use `rgba(30, 41, 59, 0.6)`.
2.  **Micro-Shadows**: Instead of heavy global shadows, use "Ambient Glows."
    *   **Level 1 (Static Cards)**: 0px 4px 20px rgba(0, 0, 0, 0.05).
    *   **Level 2 (Active/Floating)**: 0px 10px 30px rgba(0, 0, 0, 0.08).
    *   **Dark Mode**: Shadows should be darker and narrower (rgba(0, 0, 0, 0.4)) to prevent a washed-out look.
3.  **Outlines**: All glassmorphic elements must have a subtle 1px inner border (stroke) at 10% opacity white to catch the "light" and define the edges.

## Shapes
The shape language is defined by large, friendly radii. 
- **Standard Cards**: 24px corner radius.
- **Buttons & Chips**: Fully rounded (pill-shaped) to represent motion and aerodynamics.
- **Bottom Sheets**: Top-only radius of 32px to create a soft, inviting container for trip details.
- **Map Markers**: Teardrop shapes with an 8px internal radius for the center icon.

## Components

### Floating Cards
Used for "Nearby Carts" or "Profile" glimpses. These should appear detached from the screen edges with a consistent 20px margin and the defined glassmorphic blur.

### Bottom Sheets
The primary interface for ride hailing. Sheets should support three states: collapsed (peak), expanded (half-screen), and full-screen. Include a 40px wide, 4px tall "grabber" at the top with a 20% opacity neutral color.

### Buttons
- **Primary**: Solid Emerald (#10B981) with white text. High-gloss finish or subtle top-to-bottom gradient.
- **Secondary**: Translucent background with a 1px border matching the text color.
- **Theme Toggle**: A floating circular button (48x48px) using the glassmorphic style, containing a morphing Sun/Moon icon.

### Map Markers
- **Pickup**: Amber circle with a white center dot.
- **Dropoff**: Coral circle with a white "X" or square center.
- **Autonomous Cart**: A custom icon showing the cart's heading; use the Primary Emerald color with a subtle pulse animation when "Arriving."

### Input Fields
Soft backgrounds (#F1F5F9 in light, #1E293B in dark) with 16px padding. Active states should transition the border color to Emerald Mint.