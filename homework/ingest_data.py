import pandas as pd
from sqlalchemy import create_engine, inspect
from tqdm.auto import tqdm
import click

def ingest(pg_user, pg_password, pg_host, pg_port, pg_db, target_table_1, target_table_2,chunksize):
    engine = create_engine(f'postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_db}')
    url1 = 'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet'
    url2 = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv'

    # Read parquet file and create chunks
    df1 = pd.read_parquet(url1)
    df_iter1 = [df1.iloc[i:i+chunksize] for i in range(0, len(df1), chunksize)]
    
    df_iter2 = pd.read_csv(url2,
                        iterator = True,
                        chunksize = chunksize
                        )
    
    # Check if table exists
    inspector = inspect(engine)
    table_1_exists = target_table_1 in inspector.get_table_names()
    table_2_exists = target_table_2 in inspector.get_table_names()

    first_chunk = True

    for df_chunk in tqdm(df_iter1):

        if first_chunk:
            # Only use 'replace' if table doesn't exist, otherwise append
            if_exists_mode = 'replace' if not table_1_exists else 'append'
            df_chunk.head(0).to_sql(name=target_table_1,
                                    con=engine,
                                    if_exists=if_exists_mode
                                    )
            first_chunk = False

            if table_1_exists:
                print(f'Appending to existing table {target_table_1} in database {pg_db}')
            else:
                print(f'Created table {target_table_1} in database {pg_db}')

        df_chunk.to_sql(name=target_table_1,
                        con=engine,
                        if_exists='append'
                        )
        print(f'Inserted another {len(df_chunk)} rows to table {target_table_1}')

    first_chunk = True

    for df_chunk in tqdm(df_iter2):

        if first_chunk:
            # Only use 'replace' if table doesn't exist, otherwise append
            if_exists_mode = 'replace' if not table_2_exists else 'append'
            df_chunk.head(0).to_sql(name=target_table_2,
                                    con=engine,
                                    if_exists=if_exists_mode
                                    )
            first_chunk = False

            if table_2_exists:
                print(f'Appending to existing table {target_table_2} in database {pg_db}')
            else:
                print(f'Created table {target_table_2} in database {pg_db}')
        df_chunk.to_sql(name=target_table_2,
                        con=engine,
                        if_exists='append'
                        )
        print(f'Inserted another {len(df_chunk)} rows to table {target_table_2}')

@click.command()
@click.option('--pg-user', default='root', help='PostgreSQL user')
@click.option('--pg-password', default='root', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-port', default=5432, type=int, help='PostgreSQL port')
@click.option('--pg-db', default='ny_taxi', help='PostgreSQL database')
@click.option('--target-table-1', default='yellow_taxi_data', help='Target table name')
@click.option('--target-table-2', default='taxi_zone_lookup', help='Target table name')
@click.option('--chunksize', default=100000, type=int, help='Chunk size for reading CSV')

def main(pg_user, pg_password, pg_host, pg_port, pg_db, target_table_1, target_table_2, chunksize):
    """Ingest NYC taxi data into PostgreSQL database."""
    ingest(pg_user, pg_password, pg_host, pg_port, pg_db, target_table_1, target_table_2,chunksize)

if __name__ == '__main__':
        main()