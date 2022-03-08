import { baseContext } from "../shared/contexts";
import { testErc20Permit } from "./token/erc20-permit/Erc20Permit";
import { testErc20Recover } from "./token/erc20-recover/Erc20Recover";
import { testErc20 } from "./token/erc20/Erc20";

baseContext("Unit Tests", function () {
  testErc20();
  testErc20Permit();
  testErc20Recover();
});
