# backend/services/tag_ai_service.py
import logging
from core.brain.ai_brain import AIBrain

logger = logging.getLogger("tag-ai-api")


class TagAIService:
    """Service adapter bridging the FastAPI backend to the existing Tag AI Core."""

    def __init__(self):
        try:
            self.brain = AIBrain()
            logger.info("TagAIService adapter connected to canonical AIBrain successfully.")
        except Exception as e:
            logger.critical("Failed to connect to AIBrain: %s", e, exc_info=True)
            self.brain = None

    def ask_brain(self, message: str) -> str:
        """Send user input to the AIBrain and obtain normalized responses."""
        if self.brain is None:
            logger.error("AIBrain instance is unavailable.")
            raise RuntimeError("Tag AI Brain system is offline.")

        try:
            logger.info("Dispatching query to Tag AI Brain Core...")
            response = self.brain.think(message)
            logger.info("Successfully received response from Tag AI Brain Core.")
            return response
        except Exception as e:
            logger.error("Error communicating with Tag AI Brain: %s", e, exc_info=True)
            raise RuntimeError(f"Brain execution failure: {e}")


# Singleton instance of the service adapter
tag_ai_service = TagAIService()
