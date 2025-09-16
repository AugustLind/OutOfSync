/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: '#007AFF',
        secondary: '#5856D6',
        success: '#34C759',
        warning: '#FF9500',
        destructive: '#FF3B30',
        background: {
          DEFAULT: '#F2F2F7',
          dark: '#000000',
        },
        card: {
          DEFAULT: '#FFFFFF',
          dark: '#1C1C1E',
        },
        textPrimary: {
          DEFAULT: '#000000',
          dark: '#FFFFFF',
        },
        textSecondary: {
          DEFAULT: '#8E8E93',
          dark: '#8E8E93',
        },
        border: {
          DEFAULT: '#E5E5EA',
          dark: '#38383A',
        },
      },
      borderRadius: {
        'ios': '12px',
      },
      boxShadow: {
        'ios': '0 2px 8px rgba(0, 0, 0, 0.05)',
        'ios-dark': '0 2px 8px rgba(0, 0, 0, 0.3)',
      }
    },
  },
  plugins: [],
}