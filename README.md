# TodoApi (branch: 2.0.0)

App created to practise the blog posts of blog.codeship.com about Elixir/Phoenix.

**Blog posts which was read:**

- [x] https://blog.codeship.com/an-introduction-to-apis-with-phoenix/
- [x] https://blog.codeship.com/ridiculously-fast-api-authentication-with-phoenix/
- [x] https://blog.codeship.com/refactoring-faster-can-spell-phoenix/

---

**Variations of the original implementation ([master](https://github.com/serradura/phx-todo_api/tree/master)):**

(List from best to worst)

  * [TodoApi.Accounts.Authentication + Todos functions receive the owner as keywords](https://github.com/serradura/phx-todo_api/pull/5)
  * [TodoApi.Accounts.Authentication + Todos.WithOwner](https://github.com/serradura/phx-todo_api/pull/4)
  * [Create TodoApi.Accounts.Authentication](https://github.com/serradura/phx-todo_api/pull/3)
  * [Add CurrentUser context](https://github.com/serradura/phx-todo_api/pull/2)

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

---

To run the test suite:

  * `mix test`

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
