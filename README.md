# Volume Pricing

[![CircleCI](https://circleci.com/gh/solidusio-contrib/solidus_volume_pricing.svg?style=svg)](https://circleci.com/gh/solidusio-contrib/solidus_volume_pricing)
[![Code Climate](https://codeclimate.com/github/solidusio-contrib/solidus_volume_pricing/badges/gpa.svg)](https://codeclimate.com/github/solidusio-contrib/solidus_volume_pricing)

Volume Pricing is an extension to Solidus that uses predefined ranges of quantities to determine the
price for a particular product variant.

For instance, this allows you to set a price for quantities between 1-10, another price for
quantities between (10-100) and another for quantities of 100 or more. If no volume price is defined
for a variant, then the standard price is used.

Each VolumePrice contains the following values:

1. **Variant:** Each VolumePrice is associated with a _Variant_, which is used to link products to
   particular prices.
2. **Name:** The human readable representation of the quantity range (Ex. 10-100). (Optional)
3. **Discount Type** The type of discount to apply.
     * **Price:** sets price to the amount specified for all items
     * **Dollar:** subtracts specified amount from the Variant price for all items
     * **Percent:** subtracts the specified amounts percentage from the Variant price for all items
     * **Banded Price:** sets price to the amount specified, but only for items within the range. For items outside the range it will consult that band to determine price
     * **Banded Dollar:** subtracts specified amount from the Variant price, but only for items within the range. For items outside the range it will consult that band to determine price
     * **Banded Percent:** subtracts the specified amounts percentage from the Variant price, but only for items within the range. For items outside the range it will consult that band to determine price
4. **Range:** The quantity range for which the price is valid (See Below for Examples of Valid
   Ranges.)
5. **Amount:** The price of the product if the line item quantity falls within the specified range.
6. **Position:** Integer value for `acts_as_list` (Helps keep the volume prices in a defined order.)

Note: when using percentage based or banded discounts then first the system will calculate a per-item price, and then get the total by multiplying the per-item price with the quantity. Due to rounding this can differ if the price would have been calculated on the total.

Example: Percent discount is 10%, Original price is 9.99, Ordering 100 pieces. Per-item price is rounded down to $8.99 (from $8.991), so total will be $899.00 instead of $899.10

## Install

The extension contains a rails generator that will add the necessary migrations and give you the
option to run the migrations, or run them later, perhaps after installing other extensions. Once you
have bundled the extension, run the install generator and its ready to use.

      rails generate solidus_volume_pricing:install

Easily add volume pricing display to your product page:

      <%= render partial: 'spree/products/volume_pricing', locals: { product: @product } %>

## Ranges

Ranges are expressed as Strings and are similar to the format of a Range object in Ruby. The lower
number of the range is always inclusive.  If the range is defined with '..' then it also includes
the upper end of the range.  If the range is defined with '...' then the upper end of the range is
not inclusive.

Ranges can also be defined as "open ended."  Open ended ranges are defined with an integer followed
by a '+' character.  These ranges are inclusive of the integer and any value higher then the
integer.

All ranges need to be expressed as Strings and can include or exclude parentheses.  "(1..10)" and
"1..10" are considered to be a valid range.

## Examples

Consider the following examples of volume prices:

| Variant | Name | Range | Amount | Position |
| ------- | ---- | ----- | ------ | -------- |
| Rails T-Shirt | 1-5 | (1..5) | 19.99 | 1 |
| Rails T-Shirt | 6-9 | (6...10) | 18.99 | 2 |
| Rails T-Shirt | 10 or more | (10+) | 17.99 | 3 |

### Example 1

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 1 | 19.99 | 19.99 |

### Example 2

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 5 | 19.99 | 99.95 |

### Example 3

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 6 | 18.99 | 113.94 |

### Example 4

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 10 | 17.99 | 179.90 |

### Example 5

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 20 | 17.99 | 359.80 |

## Banded Examples

Consider the following examples of volume prices:

| Variant | Name | Type | Range | Amount | Position |
| ------- | ---- | ---- | ----- | ------ | -------- |
| Rails T-Shirt | 1-5 | Price | (1..5) | 19.99 | 1 |
| Rails T-Shirt | 6-9 | Price | (6...10) | 18.99 | 2 |
| Rails T-Shirt | 10-19 | Banded Percent | (10-19) | 50% | 3 |
| Rails T-Shirt | 20 or more | Banded Percent | (20+) | 75% | 4 |

### Example 1

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 1 | 19.99 | 19.99 |

### Example 2

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 5 | 19.99 | 99.95 |

### Example 3

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 6 | 18.99 | 113.94 |

### Example 4

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 10 | 18.09 | 180.90 |

Items #1-9 will be priced according to the `(5..9)` rule as it is unbanded. Their price will be $170.91

Item #10 will be priced according to the `(10+)` rule, which describes a 50% reduction to the base price, which is $9.99 (rounded down)

### Example 5

Cart Contents:

| Product | Quantity | Price | Total |
| ------- | -------- | ----- | ----- |
| Rails T-Shirt | 20 | 13.79 | 275.80 |

Items #1-9 will be priced according to the `(5..9)` rule as it is unbanded. Their price will be $170.91

Items #10-19 will be priced according to the `(10-19)` rule, which describes a 50% reduction to the base price. This equates to $9.99 per item (rounded down)

Item #20 will be priced according to the `(20+)` rule, which describes a 75% reduction to the base price. This would be $4.99 (rounded down)

A per-item price of $13.79 is calculated (rounded down from $13.792875), then multiplied by the quantity getting $275.80. Note: this is $0.05 lower than what you would get if you total up the items separately, see notes above.

## License

Copyright (c) 2009-2015 [Spree Commerce][2] and [contributors][3], released under the
[New BSD License][4].

[1]: https://github.com/solidusio-contrib/solidus_volume_pricing/blob/master/CONTRIBUTING.md
[2]: https://github.com/spree
[3]: https://github.com/solidusio-contrib/solidus_volume_pricing/graphs/contributors
[4]: https://github.com/solidusio-contrib/solidus_volume_pricing/blob/master/LICENSE.md
