alias PromoCodeApi.SafeBoda.Promo
alias PromoCodeApi.Repo

Repo.insert! %Promo{
    code: "CHRISTOPHERVU12",
    amount: 500,
    event_id: 1,
    radius: 50.0,
    expiry_date: Date.add(Date.utc_today, 10),
}


