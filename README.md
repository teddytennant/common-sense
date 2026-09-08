# common-sense

A skill that gives a coding agent the judgment a competent engineer already has.

Agents fail in boring ways. They invent an API they remember from training. They
claim tests passed. They add a second file next to the one that already had a
home for the change. They interview you about a choice that does not matter.
They write a README section that exists because READMEs usually have one.

This is one `SKILL.md` that says: look first, do the smallest thing, verify or
do not claim, do not perform. It is short enough to load, and specific enough
that the model has something to disobey on purpose.

Works in [Claude Code](https://claude.com/claude-code),
[Wizard](https://github.com/teddytennant/wizard),
[Codex](https://developers.openai.com/codex/skills), and
[Pi](https://pi.dev/docs/latest/skills). Same file.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/teddytennant/common-sense/main/install.sh | bash
```

That installs into whichever of `claude`, `wizard`, `codex`, and `pi` it finds,
and always writes `~/.agents/skills/common-sense` as well, which Codex and Pi
both read. Restart the agent, or run `/reload` in Wizard.

<details>
<summary>Manual install</summary>

Claude Code:

```
/plugin marketplace add teddytennant/common-sense
/plugin install common-sense@common-sense
```

Or copy the skill:

```bash
mkdir -p ~/.claude/skills/common-sense
curl -fsSL https://raw.githubusercontent.com/teddytennant/common-sense/main/skills/common-sense/SKILL.md \
  -o ~/.claude/skills/common-sense/SKILL.md
```

Wizard, from a checkout:

```bash
git clone https://github.com/teddytennant/common-sense
bash common-sense/plugins/common-sense/wizard/install.sh
```

Codex:

```bash
mkdir -p ~/.codex/skills/common-sense ~/.agents/skills/common-sense
curl -fsSL https://raw.githubusercontent.com/teddytennant/common-sense/main/skills/common-sense/SKILL.md \
  -o ~/.codex/skills/common-sense/SKILL.md
cp ~/.codex/skills/common-sense/SKILL.md ~/.agents/skills/common-sense/SKILL.md
```

Pi:

```bash
mkdir -p ~/.pi/agent/skills/common-sense ~/.agents/skills/common-sense
curl -fsSL https://raw.githubusercontent.com/teddytennant/common-sense/main/skills/common-sense/SKILL.md \
  -o ~/.pi/agent/skills/common-sense/SKILL.md
cp ~/.pi/agent/skills/common-sense/SKILL.md ~/.agents/skills/common-sense/SKILL.md
```

</details>

## Use

It triggers on its own when the model is about to invent an API, claim a test,
add a file, or ask you which of three identical options you prefer. You can
also call it:

```
/common-sense
```

With no arguments it loads the rules for the rest of the session. Point it at
a diff or some text and it will cut that down instead.

## What it actually enforces

Look at the repo before you invent a path, an API, a flag, or a version. Edit
the file that already does the thing. Solve the request, not the plugin system
the request hints at. Never name a test you did not see pass. Ask only when
the *goal* is ambiguous.

Ten named traps, so the model has something concrete to refuse:

1. Phantom import
2. The extra file
3. The interview
4. The second system
5. Success hallucination
6. The apology loop
7. Catch-all
8. Drive-by
9. Ceremony README
10. The bow

The full rules are in [SKILL.md](skills/common-sense/SKILL.md). Read it. You
are the one who has to agree with it.

## License

MIT
