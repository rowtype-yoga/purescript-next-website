import { Prism } from 'react-syntax-highlighter';
export { dark } from 'react-syntax-highlighter/dist/esm/styles/prism';

export { docco } from 'react-syntax-highlighter/dist/esm/styles/hljs';

export { default as haskell } from 'react-syntax-highlighter/dist/esm/languages/hljs/haskell';
import haskell from 'react-syntax-highlighter/dist/esm/languages/hljs/haskell';
// Prism.registerLanguage('purescript', haskell);
export const syntaxHighlighter = Prism
export const registerLanguageImpl = (highlighter) => (alias, language) => () => highlighter.registerLanguage(alias, language)
