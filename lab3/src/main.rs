use std::error::Error;

use fake::faker::name::raw::Name;
use fake::locales::EN;
use fake::{Dummy, Fake};
use postgres::{Client, NoTls};

#[derive(Debug, Dummy)]
struct GeneratedAuthor {
    #[dummy(faker = "Name(EN)")]
    name: String,
}

#[derive(Debug, Dummy)]
struct GeneratedBook {
    #[dummy(faker = "1000..9999")]
    title_code: i32,
}

fn main() -> Result<(), Box<dyn Error>> {
    let mut conn = Client::connect(
        "host=localhost user=postgres password=root dbname=postgres",
        NoTls,
    )?;

    let mut author_ids = Vec::new();

    for _ in 0..10 {
        let author: GeneratedAuthor = fake::Faker.fake();

        let row = conn.query_one(
            "INSERT INTO authors (name) VALUES ($1) RETURNING author_id",
            &[&author.name],
        )?;

        let author_id: i32 = row.get(0);
        author_ids.push(author_id);
    }

    for i in 0..80 {
        let book: GeneratedBook = fake::Faker.fake();
        let author_id = author_ids[i % author_ids.len()];
        let title = format!("Technical book {}", book.title_code);

        conn.execute(
            "INSERT INTO books (title, author_id) VALUES ($1, $2)",
            &[&title, &author_id],
        )?;
    }

    Ok(())
}
