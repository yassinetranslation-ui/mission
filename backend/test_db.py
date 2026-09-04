from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.user import User

engine = create_engine('sqlite:///./misson.db')
Session = sessionmaker(bind=engine)
db = Session()

try:
    print(db.query(User).all())
    print("DB OK")
except Exception as e:
    import traceback
    traceback.print_exc()
