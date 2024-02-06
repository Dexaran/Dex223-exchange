// SPDX-License-Identifier: GPL-3.0

// Contracts are written by @Dexaran (twitter.com/Dexaran github.com/Dexaran)

pragma solidity >=0.8.2;

abstract contract Dex223MarginModule {

    event OrderPlaced(uint256 _orderId, address _asset, uint256 _deadline, uint256 _interest, uint256 _collateral, address[] _pairs, address[] _collateral_assets, address[] _liquidators, uint256 _liq_reward, address _mark_price, bool _antiflashloan);

/*
    modifier onlyLender
    {
        _;
    }

    modifier onlyExpiredOrder
    {
        _;
    }
*/
    function placeOrder(address _asset,    // Asset that was provided for borrowing.
                                           // If `_asset` is `address(0)` then the asset is native currency (ETH on Ethereum).

                        uint256 _deadline, // Expiration date of the lending order in UNIX timestamp. 
                                           // Position can be forcefully closed after this date.
                                           // If this value is set to `0` then this lending order is a perpetual contract.

                        uint256 _interest_rate, // Determines the interest rate per 30 days demanded by the lender,
                                                // this value will be divided by `10000` in calculations
                                                // i.e. `_interest_rate = 3000` is 30% per 30 days.
                                                // If at any given point of time the cumulative value of the assets stored in this order
                                                // is less than `(block.timestamp - order.creation_date) / 30 days * (order.initial_balance + order.initial_balance * _interest_rate)
                                                // then the order is subjected to liquidation.

                        uint256 _collateral_requirement, // Determines the requirement of collateral demanded by the lender.
                                                         // This value determines the maximum "leverage" that can be achieved using the funds
                                                         // stored in this lending order.

                        address[] calldata _tradeable_pairs, // Which pairs can be traded with the funds borrowed from this order.
                                                             // The lender can disallow the borrower to trade some assets with his/her funds
                                                             // by not including the pair in this list.
                                                             // If the `_tradeable_pairs[0]` is `address(0x0)` then there are no explusions
                                                             // and the borrower can trade anything.
                                                             // IMPORTANT: Address provided in this list can be an address of an auto-listing contract
                                                             //            in this case all the assets present in the auto-listing contract
                                                             //            are whitelisted for trading with the borrowed funds.


                        address[] calldata _accepted_collateral, // Determines which assets are accepted as a collateral.
                                                                 // The lender can accept only select assets.

                        address[] calldata _whitelisted_liquidator, // Allows the lender to specify addresses that are allowed to liquidate this order.
                                                                    // If the `_whitelisted_liquidator[0]` is `address(0)` then
                                                                    // anyone is allowed to call liquidation function on this order and get the reward.
                                                                    // We expect that the lender can have a longterm contract with some
                                                                    // liquidation services provider and the payment for the liquidations can be processed off-chain
                                                                    // or the lender can run liquidation watchdog script themselve.

                        uint256 _liquidation_reward, // The amount of reward that will be paid to the liquidator of this position.
                                                     // Acts similar to `gasPrice` for transactions, i.e. the higher the reward
                                                     // the higher the chance that someone will call the liquidation function on time.

                        address _mark_price,  // The source of price that will be used for liquidation calculations.
                                              // It can be an oracle or a market price at the moment of position execution.

                        bool    _antiflash_delay // If `true` then the liquidation function will not immediately liquidate the position,
                                                 // but instead it will "freeze" it for few blocks.
                                                 // After select number of blocks passes the liquidation function can be called on the frozen order
                                                 // and if it is still subject to liquidation then it will be liquidated.
                                                 // This mechanic allows to protect the lender from flash-loan attack
                                                 // that can target his position.
                                                 // The lender can disable this anti flash loan protection to save gas and lower the efforts
                                                 // required to liquidate the position, but it exposes him/her to the risks of flash loan attacks.

                        ) public virtual returns (uint256 orderId);

    function closePosition(uint256 _orderId) public virtual returns (bool);
    function withdrawProfit(uint256 _orderId) public virtual /* onlyLender() */ /* onlyExpiredOrder() */ returns (bool);
    function subjectToLiquidation(uint256 _orderId) public virtual view returns (bool);
    function liquidate(uint256 _oderId) public virtual returns (bool);
}

/*
contract TestMarginModule
{
    
    event OrderPlaced(uint256 _orderId, address _asset, uint256 _deadline, uint256 _interest, uint256 _collateral, address[] _pairs, address[] _collateral_assets, address[] _liquidators, uint256 _liq_reward, address _mark_price, bool _antiflashloan);

    function placeOrder(address _asset,
                        uint256 _deadline,
                        uint256 _interest_rate,
                        address[] calldata _tradeable_pairs,
                        address[] calldata _accepted_collateral,
                        address[] calldata _liquidator,
                        uint256 _liquidation_reward
                        ) public  returns (uint256 orderId)
                        {
                            address[] memory _empty;
                            emit OrderPlaced(1, address(this), 12345, 123, 1234, _empty, _empty, _empty, 54321, address(this), true);
                            return 123;
                        }
}
*/
