import sys
import os

# Asegurar que la ruta raíz del proyecto esté en PYTHONPATH
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.main import app


def test_index():
    client = app.test_client()
    r = client.get('/')
    assert r.status_code == 200


def test_api_reply_empty():
    client = app.test_client()
    r = client.post('/api/reply', json={})
    j = r.get_json()
    assert 'reply' in j


def test_api_reply_known():
    client = app.test_client()
    r = client.post('/api/reply', json={'prompt': '¿Qué es Docker?'})
    j = r.get_json()
    assert isinstance(j['reply'], str)
