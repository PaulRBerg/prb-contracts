import { baseContext } from "../shared/contexts";
import { testERC20Permit } from "./token/erc20-permit/ERC20Permit";
import { testERC20Recover } from "./token/erc20-recover/ERC20Recover";
import { testERC20 } from "./token/erc20/ERC20";

baseContext("Unit Tests", function () {
  testERC20();
  testERC20Permit();
  testERC20Recover();
});
