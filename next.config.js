// module.exports = {
//   reactStrictMode: true,
//   experimental: {
//     appDir: true,
//   },
// };
const withNextra = require('nextra')({
  theme: 'nextra-theme-docs',
  themeConfig: './theme.config.jsx',
})
 
module.exports = withNextra({
  reactStrictMode: true,
  experimental: {
    appDir: true,
  },
})
