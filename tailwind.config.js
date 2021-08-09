const colors = require('tailwindcss/colors')

module.exports = {
  darkMode: 'class',
  purge: false,
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      main: colors.trueGray, // TODO: delete after removing placeholder
      primary: colors.cyan,
      disabled: colors.warmGray,
      display: colors.trueGray,
      error: colors.red,
      secondary: colors.lime,
      white: colors.white
    },
    fontFamily: {
      mono: ['JetBrains Mono', 'monospace'],
      sans: ['Rubik', 'sans-serif']
    }
  },
  variants: {
    extend: {
      borderRadius: ['focus'],
      borderWidth: ['focus']
    }
  }
}
