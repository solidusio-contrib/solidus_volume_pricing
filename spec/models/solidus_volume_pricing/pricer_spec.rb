# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "having the variant price" do
  it "uses the variants price" do
    expect(subject).to eq("$10.00")
  end
end

RSpec.describe SolidusVolumePricing::Pricer do
  let(:other_role) { create(:role) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:variant) { create(:variant, price: 10) }

  it "inherits from default variant pricer" do
    expect(described_class < Spree::Variant::PriceSelector).to be(true)
  end

  it "has SolidusVolumePricing::PricingOptions as pricing options class" do
    expect(described_class.pricing_options_class).to eq(SolidusVolumePricing::PricingOptions)
  end

  describe "#price_for" do
    subject do
      described_class.new(variant).price_for(pricing_options).to_s
    end

    let(:quantity) { 1 }

    let(:pricing_options) do
      SolidusVolumePricing::PricingOptions.new(quantity: quantity)
    end

    context "discount_type = price" do
      before do
        variant.volume_prices.create!(amount: 7, discount_type: "price", range: "(10+)")
      end

      context "when quantity does not match the range" do
        it_behaves_like "having the variant price"
      end

      context "when quantity matches the range" do
        let(:quantity) { 10 }

        it "uses the volume price" do
          expect(subject).to eq("$7.00")
        end

        context "when volume price has a role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when no user is given" do
            it_behaves_like "having the variant price"
          end

          context "when a user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before { user.spree_roles << role }

              it "uses the volume price" do
                expect(subject).to eq("$7.00")
              end
            end

            context "whose role does not match" do
              before { user.spree_roles << other_role }

              it_behaves_like "having the variant price"
            end
          end
        end

        context "of a volume price model instead" do
          let(:quantity) { 6 }

          before do
            variant.volume_price_models << create(:volume_price_model)
            variant.volume_price_models.first.volume_prices.create!(amount: 5, discount_type: "price", range: "(5+)")
          end

          it "uses the volume price from model" do
            expect(subject).to eq("$5.00")
          end
        end
      end
    end

    context "discount_type = dollar" do
      before do
        variant.volume_prices.create!(amount: 1, discount_type: "dollar", range: "(10+)")
      end

      context "when quantity does not match the range" do
        it_behaves_like "having the variant price"
      end

      context "when quantity matches the range" do
        let(:quantity) { 10 }

        it "uses the volume price" do
          expect(subject).to eq("$9.00")
        end

        context "when volume price has a role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when no user is given" do
            it_behaves_like "having the variant price"
          end

          context "when a user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before { user.spree_roles << role }

              it "uses the volume price" do
                expect(subject).to eq("$9.00")
              end
            end

            context "whose role does not match" do
              before { user.spree_roles << other_role }

              it_behaves_like "having the variant price"
            end
          end
        end
      end

      context "of a volume price model instead" do
        let(:quantity) { 6 }

        before do
          variant.volume_price_models << create(:volume_price_model)
          variant.volume_price_models.first.volume_prices.create!(amount: 2, discount_type: "dollar", range: "(5+)")
        end

        it "uses the volume price from model" do
          expect(subject).to eq("$8.00")
        end
      end
    end

    context "discount_type = percent" do
      before do
        variant.volume_prices.create!(amount: 0.25, discount_type: "percent", range: "(10+)")
      end

      context "when quantity does not match the range" do
        it_behaves_like "having the variant price"
      end

      context "when quantity matches the range" do
        let(:quantity) { 10 }

        it "uses the volume price" do
          expect(subject).to eq("$7.50")
        end

        context "when volume price has a role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when no user is given" do
            it_behaves_like "having the variant price"
          end

          context "when a user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before { user.spree_roles << role }

              it "uses the volume price" do
                expect(subject).to eq("$7.50")
              end
            end

            context "whose role does not match" do
              before { user.spree_roles << other_role }

              it_behaves_like "having the variant price"
            end
          end
        end
      end

      context "of a volume price model instead" do
        let(:quantity) { 6 }

        it "uses the volume price from model" do
          variant.volume_price_models << create(:volume_price_model)
          variant.volume_price_models.first.volume_prices.create!(amount: 0.75, discount_type: "percent", range: "(5+)")
          expect(subject).to eq("$2.50")
        end
      end
    end

    context "discount_type is unknown" do
      before do
        variant.volume_prices.create(amount: 7, discount_type: "foo", range: "(10+)")
      end

      it_behaves_like "having the variant price"
    end

    context "when use_master_variant_volume_pricing" do
      let(:master) { variant.product.master }

      before do
        stub_spree_preferences(use_master_variant_volume_pricing: use_master_variant_volume_pricing)
        master.volume_prices.create!(amount: 1.5, discount_type: "price", range: "(1+)")
        variant.volume_prices.create!(amount: 3.5, discount_type: "price", range: "(1+)")
      end

      context "is enabled" do
        let(:use_master_variant_volume_pricing) { true }

        context "when volume prices are present on variant" do
          it "uses the variant to compute price" do
            expect(subject).to eq("$3.50")
          end
        end

        context "when no volume prices present on variant" do
          before do
            variant.volume_prices.delete_all
          end

          it "uses the master variant to compute price" do
            expect(subject).to eq("$1.50")
          end
        end
      end

      context "is disabled" do
        let(:use_master_variant_volume_pricing) { false }

        it "uses the master variant to compute price" do
          expect(subject).to eq("$3.50")
        end
      end
    end
  end

  describe "#earning_amount" do
    subject do
      described_class.new(variant).earning_amount(pricing_options).to_s
    end

    let(:pricing_options) do
      SolidusVolumePricing::PricingOptions.new(quantity: quantity)
    end

    context "discount_type = price" do
      before do
        variant.volume_prices.create!(amount: 9, discount_type: "price", range: "(10+)")
      end

      context "when quantity matches range" do
        let(:quantity) { 10 }

        it "gives amount earning" do
          expect(subject).to eq("$1.00")
        end

        context "when volume_price has role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before do
                user.spree_roles << role
              end

              it "gives amount earning" do
                expect(subject).to eq("$1.00")
              end
            end

            context "whose role does not match" do
              before do
                user.spree_roles << other_role
              end

              it "gives zero earning amount" do
                expect(subject).to eq("$0.00")
              end
            end
          end

          context "when no user is given" do
            it "gives zero earning amount" do
              expect(subject).to eq("$0.00")
            end
          end
        end
      end

      context "when quantity does not match range" do
        let(:quantity) { 1 }

        it "gives zero earning amount" do
          expect(subject).to eq("$0.00")
        end
      end
    end

    context "discount_type = dollar" do
      before do
        variant.volume_prices.create!(amount: 2.5, discount_type: "dollar", range: "(10+)")
      end

      context "when amount matches range" do
        let(:quantity) { 10 }

        it "gives amount earning" do
          expect(subject).to eq("$2.50")
        end

        context "when volume_price has role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before do
                user.spree_roles << role
              end

              it "gives amount earning" do
                expect(subject).to eq("$2.50")
              end
            end

            context "whose role does not match" do
              before do
                user.spree_roles << other_role
              end

              it "gives zero earning amount" do
                expect(subject).to eq("$0.00")
              end
            end
          end

          context "when no user is given" do
            it "gives zero earning amount" do
              expect(subject).to eq("$0.00")
            end
          end
        end
      end

      context "when amount does not match range" do
        let(:quantity) { 1 }

        it "gives zero earning amount" do
          expect(subject).to eq("$0.00")
        end
      end
    end

    context "discount_type = percent" do
      before do
        variant.volume_prices.create!(amount: 0.75, discount_type: "percent", range: "(10+)")
      end

      context "when amount matches range" do
        let(:quantity) { 10 }

        it "gives amount earning" do
          expect(subject).to eq("$7.50")
        end

        context "when volume_price has role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before do
                user.spree_roles << role
              end

              it "gives amount earning" do
                expect(subject).to eq("$7.50")
              end
            end

            context "whose role does not match" do
              before do
                user.spree_roles << other_role
              end

              it "gives zero earning amount" do
                expect(subject).to eq("$0.00")
              end
            end
          end

          context "when no user is given" do
            it "gives zero earning amount" do
              expect(subject).to eq("$0.00")
            end
          end
        end
      end

      context "when amount does not match range" do
        let(:quantity) { 1 }

        it "gives zero earning amount" do
          expect(subject).to eq("$0.00")
        end
      end
    end
  end

  describe "#earning_percent" do
    subject do
      described_class.new(variant).earning_percent(pricing_options)
    end

    let(:pricing_options) do
      SolidusVolumePricing::PricingOptions.new(quantity: quantity)
    end

    context "discount_type = price" do
      before do
        variant.volume_prices.create!(amount: 9, discount_type: "price", range: "(10+)")
      end

      context "when quantity matches range" do
        let(:quantity) { 10 }

        it "gives percent of earning" do
          expect(subject).to eq(10)
        end

        context "when volume_price has role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before do
                user.spree_roles << role
              end

              it "gives percent of earning if role matches" do
                expect(subject).to eq(10)
              end
            end

            context "whose role doesnt match" do
              before do
                user.spree_roles << other_role
              end

              it "gives zero percent earning" do
                expect(subject).to eq(0)
              end
            end
          end

          context "when no user is given" do
            it "gives zero earning amount" do
              expect(subject).to eq(0)
            end
          end
        end
      end

      context "when quantity does not match range" do
        let(:quantity) { 1 }

        it "gives zero percent earning" do
          expect(subject).to eq(0)
        end
      end
    end

    context "discount_type = dollar" do
      before do
        variant.volume_prices.create!(amount: 2.5, discount_type: "dollar", range: "(10+)")
      end

      context "when quantity matches range" do
        let(:quantity) { 10 }

        it "gives percent of earning" do
          expect(subject).to eq(25)
        end

        context "when volume_price has role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before do
                user.spree_roles << role
              end

              it "gives percent of earning if role matches" do
                expect(subject).to eq(25)
              end
            end

            context "whose role doesnt match" do
              before do
                user.spree_roles << other_role
              end

              it "gives zero percent earning" do
                expect(subject).to eq(0)
              end
            end
          end

          context "when no user is given" do
            it "gives zero earning amount" do
              expect(subject).to eq(0)
            end
          end
        end
      end

      context "when quantity does not match range" do
        let(:quantity) { 1 }

        it "gives zero percent earning" do
          expect(subject).to eq(0)
        end
      end
    end

    context "discount_type = percent" do
      before do
        variant.volume_prices.create!(amount: 0.25, discount_type: "percent", range: "(10+)")
      end

      context "when quantity matches range" do
        let(:quantity) { 10 }

        it "gives percent of earning" do
          expect(subject).to eq(25)
        end

        context "when volume_price has role" do
          before do
            variant.volume_prices.first.update(role_id: role.id)
          end

          context "when user is given" do
            let(:pricing_options) do
              SolidusVolumePricing::PricingOptions.new(
                quantity: quantity,
                user: user
              )
            end

            context "whose role matches" do
              before do
                user.spree_roles << role
              end

              it "gives percent of earning if role matches" do
                expect(subject).to eq(25)
              end
            end

            context "whose role doesnt match" do
              before do
                user.spree_roles << other_role
              end

              it "gives zero percent earning" do
                expect(subject).to eq(0)
              end
            end
          end

          context "when no user is given" do
            it "gives zero earning amount" do
              expect(subject).to eq(0)
            end
          end
        end
      end

      context "when quantity does not match range" do
        let(:quantity) { 1 }

        it "gives zero percent earning" do
          expect(subject).to eq(0)
        end
      end
    end
  end
end
