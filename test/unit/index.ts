import { baseContext } from "../shared/contexts";
import { testErc20Permit } from "./token/erc20Permit/Erc20Permit";
import { testErc20Recover } from "./token/erc20Recover/Erc20Recover";

baseContext("Unit Tests", function () {
  testErc20Permit();
  testErc20Recover();
});
