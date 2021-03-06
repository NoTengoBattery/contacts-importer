const colors = require('tailwindcss/colors')

module.exports = {
  darkMode: 'class',
  purge: false,
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      primary: colors.cyan,
      disabled: colors.warmGray,
      display: colors.trueGray,
      error: colors.red,
      success: colors.green,
      white: colors.white
    },
    container: {
      center: true
    },
    fontFamily: {
      mono: ['JetBrains Mono', 'monospace'],
      sans: ['Rubik', 'sans-serif']
    },
    minWidth: {
      32: '8rem'
    }
  },
  variants: {
    extend: {
      borderRadius: ['focus'],
      borderWidth: ['focus']
    }
  }
}
