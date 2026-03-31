/* eslint-env node */
module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  plugins: ['mirego'],
  extends: ['plugin:mirego/recommended'],
  globals: {
    $: 'readonly',
    sortable: 'readonly'
  },
  rules: {
    'operator-linebreak': ['error', 'after']
  }
};
