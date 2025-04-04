import os
import logging
from pysqlcipher3 import dbapi2 as sqlite

class Storage:
    def __init__(self, passphrase, db_path):
        self.passphrase = passphrase
        self.db_path = os.path.join(db_path, "identity_wallet.db")

        # Connect to encrypted DB or create one
        self.conn = sqlite.connect(self.db_path)
        self.cursor = self.conn.cursor()

    def create_DB(self):
        # Set up encryption
        self.cursor.execute(f"PRAGMA key='{self.passphrase}';")

        # Create table for identities
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS identities (
                id INTEGER PRIMARY KEY,
                did TEXT NOT NULL,
                data TEXT NOT NULL,
                metadata TEXT
            );
        ''')
    
    def exists(self):
        if not os.path.exists(self.db_path):
            return False

        try:
            # Apply the decryption key
            self.cursor.execute(f"PRAGMA key = '{self.passphrase}';")

            # Optional: Check if PRAGMA works (will fail if key is wrong)
            self.cursor.execute("PRAGMA cipher_integrity_check;")
            result = self.cursor.fetchone()
            if result is None or result != "ok":
                logging.info("❌ Integrity check failed")
                return False

            # Check if 'identities' table exists
            self.cursor.execute('''
                SELECT name FROM sqlite_master
                WHERE type='table' AND name='identities';
            ''')
            exists = self.cursor.fetchone() is not None
            self.conn.close()
            return exists
        except Exception as e:
            logging.info("❌ Error while validating DB:", e)
            return False

    def insert_identity(self, did, data, metadata):
        # Apply the decryption key
        self.cursor.execute(f"PRAGMA key = '{self.passphrase}';")
        # Insert identity
        self.cursor.execute('''
            INSERT INTO identities (did, data, metadata)
            VALUES (?, ?, ?)
        ''', (did, data, metadata))

    def get_identity(self, did):
        # Apply the decryption key
        self.cursor.execute(f"PRAGMA key = '{self.passphrase}';")
        # Get specific identity
        self.cursor.execute('''
            SELECT data FROM identities
            WHERE did = ?
        ''', (did,))
        identity = self.cursor.fetchone()[0]
        return identity

    def close_database(self):
        self.conn.commit()
        self.conn.close()

