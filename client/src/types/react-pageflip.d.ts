declare module "react-pageflip" {
  import type {
    ForwardRefExoticComponent,
    PropsWithChildren,
    RefAttributes,
  } from "react";

  export interface HTMLFlipBookMethods {
    pageFlip(): {
      flipNext(): void;
      flipPrev(): void;
      turnToPage?(page: number): void;
      getCurrentPageIndex?(): number;
    };
  }

  export type HTMLFlipBookProps = PropsWithChildren<Record<string, unknown>>;

  const HTMLFlipBook: ForwardRefExoticComponent<
    HTMLFlipBookProps & RefAttributes<HTMLFlipBookMethods>
  >;

  export default HTMLFlipBook;
}
