import os

# Modo hybrid: si se configura OPENAI_API_KEY, intentará usar OpenAI (opcional).
# Si no existe, usará una lógica local simple (reglas/plantillas) como fallback "AI".

OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY')


def ai_reply(prompt: str) -> str:
    prompt = (prompt or '').strip()

    if not prompt:
        return "Pregúntame algo: por ejemplo, '¿Qué es CI/CD?'"

    # Si el usuario proveyó una API key, intentamos llamar a OpenAI SDK (opcional)
    if OPENAI_API_KEY:
        try:
            import openai
            openai.api_key = OPENAI_API_KEY

            resp = openai.Completion.create(
                engine='text-davinci-003',
                prompt=f"Responde brevemente y con ejemplos a: {prompt}",
                max_tokens=150,
                temperature=0.7,
            )
            return resp.choices[0].text.strip()

        except Exception as e:
            # si falla, seguimos con fallback local
            print('OpenAI call failed:', e)

    # Fallback local: reglas sencillas
    p = prompt.lower()

    if 'ci/cd' in p or 'cicd' in p:
        return (
            "CI/CD significa Integración Continua y Entrega/Despliegue Continuo. "
            "En resumen: 1) los cambios se integran con frecuencia, "
            "2) pruebas automatizadas, 3) imágenes/artefactos se construyen "
            "y 4) se despliegan automáticamente."
        )

    if 'docker' in p:
        return (
            "Docker es una plataforma para empaquetar aplicaciones en contenedores ligeros. "
            "Una imagen contiene todo lo necesario y un contenedor la ejecuta."
        )

    if 'hola' in p or 'hello' in p:
        return "¡Hola! Soy tu microservicio AI. Pregúntame sobre CI/CD, Docker o despliegues."

    # Respuesta genérica usando plantilla
    return (
        f"Interesante pregunta: '{prompt}'. "
        "Aquí hay una respuesta genérica: intenta proporcionar más contexto."
    )
