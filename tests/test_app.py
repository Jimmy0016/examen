import json
from app.main import app


def test_index():
    client = app.test_client()
    r = client.get('/')
    assert r.status_code == 200


def test_api_reply_empty():
    client = app.test_client()
    r = client.post('/api/reply', json={})
    j = r.get_json()
    assert 'Pregúntame' in j['reply'] or isinstance(j['reply'], str)


def test_api_reply_known():
    client = app.test_client()
    r = client.post('/api/reply', json={'prompt': '¿Qué es Docker?'})
    j = r.get_json()
    assert 'Docker' in j['reply'] or 'contenedor' in j['reply']
