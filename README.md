# PromoCodeApi

## Setup
1. Clone this project
2. Setup database
3. Run `mix deps.get`
4. Run tests

The Relevant test files are:
- promo_code_api_test.exsPromoCodeApi.generate_promo_codes(10, event.id, 20)
- promo_code_controller_test.exs


### Promocode Generation
`PromoCodeApi.generate_promo_codes(number, event_id, span_in_days, radius \\ 50.0)`

### Update Promo Code Radius
`PromoCodeApi.update_promo_radius(promo, new_radius)`

### Deactivate Promo
`PromoCodeApi.deactivate_promo(promo)`

### Return Active Promo Codes
`PromoCodeApi.SafeBoda.list_active_promos()`

### Return All Promo Codes
`PromoCodeApi.SafeBoda.list_promos()`

