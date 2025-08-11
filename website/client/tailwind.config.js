/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#007AFF',
        secondary: '#5856D6',
        success: '#34C759',
        warning: '#FF9500',
        destructive: '#FF3B30',
        background: '#F2F2F7',
        card: '#FFFFFF',
        textPrimary: '#000000',
        textSecondary: '#8E8E93',
      },
      borderRadius: {
        'ios': '12px',
      },
      boxShadow: {
        'ios': '0 2px 8px rgba(0, 0, 0, 0.05)',
      }
    },
  },
  plugins: [],
}