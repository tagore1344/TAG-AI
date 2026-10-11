# main_advanced.py — Run Advanced Tag AI with AI Brain
import sys
import os
import time
from assistant_with_brain import JarvisWithBrain

if __name__ == "__main__":
    print("\n" + "="*60)
    print("   🧠 Tag AI — Advanced AI Brain Edition")
    print("   WELCOME TO THE FUTURE OF AI ASSISTANTS!")
    print("="*60)
    print("\nStarting Tag AI...\n")

    tag_ai = JarvisWithBrain()
    try:
        tag_ai.start()
    except KeyboardInterrupt:
        print("\n[Tag AI] Shutting down...")
        tag_ai.stop()
    except Exception as e:
        print(f"\n[Tag AI] Error: {e}")
        import traceback
        traceback.print_exc()
        input("Press Enter to exit...")
        