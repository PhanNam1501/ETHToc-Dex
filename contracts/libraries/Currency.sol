// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

type Currency is address;

library CurrencyLibrary {
    using CurrencyLibrary for Currency;
    /// @notice Thrown when a native transfer fails
    error NativeTransferFailed();

    /// @notice Thrown when an ERC20 transfer fails
    error ERC20TransferFailed();

    Currency public constant NATIVE = Currency.wrap(address(0));

    function balanceOfSelf(Currency currency) internal view returns (uint256) {
        if (currency.isNative()) return address(this).balance;
        else return IERC20(Currency.unwrap(currency)).balanceOf(address(this));
    }

    function equals(Currency currency, Currency other) internal pure returns (bool) {
        return Currency.unwrap(currency) == Currency.unwrap(other);
    }

    function isNative(Currency currency) internal pure returns (bool) {
        return Currency.unwrap(currency) == Currency.unwrap(NATIVE);
    }

    function toId(Currency currency) internal pure returns (uint256) {
        return uint160(Currency.unwrap(currency));
    }

    function fromId(uint256 id) internal pure returns (Currency) {
        return Currency.wrap(address(uint160(id)));
    }

    function transfer(Currency currency, address to, uint256 amount) internal {
        bool success;
        if (currency.isNative()) {
            assembly {
                success := call(gas(), to, amount, 0, 0, 0, 0)
            }
            if (!success) revert NativeTransferFailed();
        } else {
            assembly {
                let freeMemoryPointer := mload(0x40)
                mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
                mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
                mstore(add(freeMemoryPointer, 36), amount)

                success := 
                    and(
                        or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
                        call(gas(), currency, 0, freeMemoryPointer, 68, 0, 32)
                    )
            }
            if (!success) revert ERC20TransferFailed();
        }
    }
}

