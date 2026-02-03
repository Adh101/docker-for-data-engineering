import pandas as pd
from sqlalchemy import create_engine, inspect
from tqdm.auto import tqdm
import click


dtype = {
    "VendorID": "Int64",
    "passenger_count": "Int64",
    "trip_distance": "float64",
    "RatecodeID": "Int64",
    "store_and_fwd_flag": "string",
    "PULocationID": "Int64",
    "DOLocationID": "Int64",
    "payment_type": "Int64",
    "fare_amount": "float64",
    "extra": "float64",
    "mta_tax": "float64",
    "tip_amount": "float64",
    "tolls_amount": "float64",
    "improvement_surcharge": "float64",
    "total_amount": "float64",
    "congestion_surcharge": "float64"
}

parse_dates = [
    "tpep_pickup_datetime",
    "tpep_dropoff_datetime"
]

def ingest(pg_user, pg_password, pg_host, pg_port, pg_db, target_table, year, month, chunksize):
    engine = create_engine(f'postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_db}')
    prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/'
    data_url = f'{prefix}/yellow_tripdata_{year}-{month:02d}.csv.gz'
    
    df_iter = pd.read_csv(data_url,
                        dtype = dtype,
                        parse_dates = parse_dates,
                        iterator = True,
                        chunksize = chunksize,
                        )
    
    # Check if table exists
    inspector = inspect(engine)
    table_exists = target_table in inspector.get_table_names()
    
    first_chunk = True

    for df_chunk in tqdm(df_iter):

        if first_chunk:
            # Only use 'replace' if table doesn't exist, otherwise append
            if_exists_mode = 'replace' if not table_exists else 'append'
            df_chunk.head(0).to_sql(name=target_table,
                                    con=engine,
                                    if_exists=if_exists_mode
                                    )
            first_chunk = False

            if table_exists:
                print(f'Appending to existing table {target_table} in database {pg_db}')
            else:
                print(f'Created table {target_table} in database {pg_db}')

        df_chunk.to_sql(name=target_table,
                        con=engine,
                        if_exists='append'
                        )
        print(f'Inserted another {len(df_chunk)} rows to table {target_table}')

@click.command()
@click.option('--pg-user', default='root', help='PostgreSQL user')
@click.option('--pg-password', default='root', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-port', default=5432, type=int, help='PostgreSQL port')
@click.option('--pg-db', default='ny_taxi', help='PostgreSQL database')
@click.option('--target-table', default='yellow_taxi_data', help='Target table name')
@click.option('--year', default=2021, type=int, help='Year of data')
@click.option('--month', default=1, type=int, help='Month of data')
@click.option('--chunksize', default=100000, type=int, help='Chunk size for reading CSV')

def main(pg_user, pg_password, pg_host, pg_port, pg_db, target_table, year, month, chunksize):
    """Ingest NYC taxi data into PostgreSQL database."""
    ingest(pg_user, pg_password, pg_host, pg_port, pg_db, target_table, year, month, chunksize)

if __name__ == '__main__':
        main()



