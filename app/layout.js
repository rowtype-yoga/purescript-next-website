import "@fontsource/inter/variable.css"

import '../styles.css'
import RL from "./root-layout"

export default function Layout({ children }) {
  return (
    <html>
      <body>
        <div id="background-container"></div>
        <RL>{children}</RL>
      </body>
    </html>
  );
}
