import { e } from "../../output/Data.Number";

export const isDarkDefault_ = () => {
  if (window.matchMedia) {
    const mediaQuery = "(prefers-color-scheme: dark)";

    const mql = window.matchMedia(mediaQuery);

    const hasPreference = typeof mql.matches === "boolean";

    if (hasPreference) {
      return mql.matches ? true : false;
    } else {
      return false;
    }
  } else {
    return false;
  }
};
