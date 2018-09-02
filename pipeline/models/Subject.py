import logging
from datetime import datetime

from sqlalchemy import Column, Integer, String, Date, Text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.ext.declarative import declarative_base

from common.logger import initialize_logger

logger = logging.getLogger(__name__)
initialize_logger(logger)

Base = declarative_base()


class Subject(Base):
    __tablename__ = 'subject'

    MAX_NAME_LENGTH = 300
    MAX_SUMMARY_LENGTH = 10000
    MAX_URL_LENGTH = 200

    id = Column('id', Integer, primary_key=True)
    true_id = Column(Integer)
    url = Column(String(MAX_URL_LENGTH))
    subject_type = Column('type', Integer)
    name = Column(String(MAX_NAME_LENGTH))
    name_cn = Column(String(MAX_NAME_LENGTH))
    summary = Column(Text)
    air_date = Column(Date)
    air_weekday = Column(Integer)
    rating = Column(JSONB)
    images = Column(JSONB)
    collection = Column(JSONB)
    rank = Column(Integer)
    eps = Column(Integer)
    eps_count = Column(Integer)

    def __init__(self, subject):
        self.parse_input(subject)

    def __repr__(self):
        return '<Subject(id = %s, true_id = %s)>' % (self.id, self.true_id)

    def update(self, subject):
        self.parse_input(subject)

    def parse_input(self, subject):
        self.id = subject.get('id')
        self.true_id = subject.get('true_id')
        self.url = self.truncate_str(subject.get('url'), self.MAX_URL_LENGTH)
        self.subject_type = subject.get('type')
        self.name = self.truncate_str(subject.get('name'), self.MAX_NAME_LENGTH)
        self.name_cn = self.truncate_str(subject.get('name_cn'), self.MAX_NAME_LENGTH)
        self.summary = self.truncate_str(subject.get('summary'), self.MAX_SUMMARY_LENGTH)
        self.air_date = self.parse_date(subject.get('air_date'))
        self.air_weekday = subject.get('air_weekday')
        self.rating = self.parse_rating(subject.get('rating'))
        self.images = self.parse_images(subject.get('images'))
        self.collection = self.parse_collection(subject.get('collection'))
        self.rank = subject.get('rank')
        self.eps = subject.get('eps')
        self.eps_count = subject.get('eps_count')

    @staticmethod
    def truncate_str(raw_str, max_length):
        """
        truncate string to max_length, or return None if it's not a string
        :param raw_str:  raw string
        :param max_length:  max length
        :return:
        """
        if not isinstance(raw_str, str):
            return None

        return raw_str[:max_length - 2] + '..' if len(raw_str) > max_length else raw_str

    @staticmethod
    def parse_date(raw_date):
        """
        Parse date into a datetime format
        :param raw_date: raw date
        :return: normalized date in datetime format
        """
        if not isinstance(raw_date, str):
            return None

        try:
            parsed_date = datetime.strptime(raw_date, '%Y-%m-%d')
            return parsed_date
        except ValueError as valueError:
            # '0000-00-00' is the most common case, we don't want to flood log with same message
            try:
                # trying to fix some common errors
                raw_date = raw_date.replace('-00', '-01')
                parsed_date = datetime.strptime(raw_date, '%Y-%m-%d')
                return parsed_date
            except ValueError as valueErrorRetry:
                if not raw_date.startswith('0000'):
                    logger.warning('Malformed date: ' + raw_date)
                    logger.warning(valueErrorRetry)
                return None

    @staticmethod
    def parse_rating(raw_rating):
        """
        Parse rating if it's a dict, else return None
        :param raw_rating: raw dating
        :return: parsed rating
        """
        if not isinstance(raw_rating, dict):
            return None

        raw_count = raw_rating.get('count', {})
        if not isinstance(raw_count, dict):
            raw_count = {}

        parsed_rating = {'total': raw_rating.get('total', 0),
                         'count': {
                             '1': raw_count.get('1', 0),
                             '2': raw_count.get('2', 0),
                             '3': raw_count.get('3', 0),
                             '4': raw_count.get('4', 0),
                             '5': raw_count.get('5', 0),
                             '6': raw_count.get('6', 0),
                             '7': raw_count.get('7', 0),
                             '8': raw_count.get('8', 0),
                             '9': raw_count.get('9', 0),
                             '10': raw_count.get('10', 0),
                         }, 'score': raw_rating.get('score', 0)}

        return parsed_rating

    @staticmethod
    def parse_images(raw_images):
        """
        Parse images if it's a dict, else return None
        :param raw_images: raw images
        :return: parsed images
        """
        if not isinstance(raw_images, dict):
            return None

        max_image_url_length = 200
        default_image = 'https://bgm.tv/img/no_icon_subject.png'

        parsed_images = {
            'large': raw_images.get('large', default_image)[:max_image_url_length],
            'common': raw_images.get('common', default_image)[:max_image_url_length],
            'medium': raw_images.get('medium', default_image)[:max_image_url_length],
            'small': raw_images.get('small', default_image)[:max_image_url_length],
            'grid': raw_images.get('grid', default_image)[:max_image_url_length],
        }

        return parsed_images

    @staticmethod
    def parse_collection(raw_collection):
        """
        Parse collection if it's a dict, else return None
        :param raw_collection: raw collection
        :return: parsed collection
        """
        if not isinstance(raw_collection, dict):
            return None

        parsed_collection = {
            'wish': raw_collection.get('wish', 0),
            'doing': raw_collection.get('doing', 0),
            'collect': raw_collection.get('collect', 0),
            'on_hold': raw_collection.get('on_hold', 0),
            'dropped': raw_collection.get('dropped', 0),
        }

        return parsed_collection
