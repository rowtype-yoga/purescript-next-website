module React.Hooks.UseRemoteData
  ( UseRemoteData(..)
  , UseRemoteDataDispatch(..)
  , useRemoteData
  , useRemoteDataDispatch
  , useRemoteDataDispatchWithDefault
  , useRemoteDataWithDefault
  ) where

import Prelude hiding (top)

import Data.Either (Either, either)
import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (class Newtype)
import Data.Traversable (for_)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff, Fiber, error, finally, forkAff, killFiber, launchAff_)
import Effect.Class (liftEffect)
import Network.RemoteData (RemoteData)
import Network.RemoteData as RD
import React.Basic.Hooks (Hook, UseEffect, UseRef, UseState, coerceHook, readRef, useEffect, writeRef)
import React.Basic.Hooks as React

newtype UseRemoteData ∷ ∀ k. k → Type → Type → Type → Type
newtype UseRemoteData i err o hooks = UseRemoteData
  ( UseRef (Maybe (Fiber Unit))
      ( UseState (RemoteData err o)
          hooks
      )
  )

derive instance Newtype (UseRemoteData i o err hooks) _

useRemoteDataWithDefault
  ∷ ∀ i o err
  . Maybe o
  → (i → Aff (Either err o))
  → Hook (UseRemoteData i err o)
      ( { data ∷ RemoteData err o
        , load ∷ i → Effect Unit
        , reset ∷ Effect Unit
        }
      )
useRemoteDataWithDefault startValue loadFn =
  coerceHook React.do
    let initialValue = maybe RD.NotAsked RD.Success startValue
    value /\ setValue ← React.useState' initialValue
    fiberRef ← React.useRef Nothing
    let
      load input =
        launchAff_ do
          cancel
          setValue RD.Loading # liftEffect
          fib ←
            forkAff
              $ finally (writeRef fiberRef Nothing # liftEffect) do
                  result ∷ Either err o ← loadFn input
                  setValue (either RD.Failure RD.Success result) # liftEffect
          writeRef fiberRef (Just fib) # liftEffect

      cancel = do
        fiberʔ <- readRef fiberRef # liftEffect
        for_ fiberʔ (killFiber (error "Cancelled"))

      reset =
        launchAff_ do
          cancel
          setValue RD.NotAsked # liftEffect
    pure
      { data: value
      , load
      , reset
      }

useRemoteData
  ∷ ∀ i o err
  . (i → Aff (Either err o))
  → Hook (UseRemoteData i err o)
      ( { data ∷ RemoteData err o
        , load ∷ i → Effect Unit
        , reset ∷ Effect Unit
        }
      )
useRemoteData = useRemoteDataWithDefault Nothing

newtype UseRemoteDataDispatch ∷ ∀ k. k → Type → Type → Type → Type
newtype UseRemoteDataDispatch i err o hooks = UseRemoteDataDispatch
  ( UseEffect (RemoteData err o)
      ( UseState (Maybe (Fiber Unit))
          ( UseState (RemoteData err o)
              hooks
          )
      )
  )

derive instance Newtype (UseRemoteDataDispatch i o err hooks) _

useRemoteDataDispatchWithDefault
  ∷ ∀ i o err
   . Eq o
  => Eq err
  => Maybe o
  → ((RemoteData err o) -> Effect Unit)
  → (i → Aff (Either err o))
  → Hook (UseRemoteDataDispatch i err o)
      ( { load ∷ i → Effect Unit
        , cancel ∷ Effect Unit
        }
      )
useRemoteDataDispatchWithDefault startValue dispatch loadFn =
  coerceHook React.do
    let initialValue = maybe RD.NotAsked RD.Success startValue
    value /\ setValue ← React.useState' initialValue
    fiber /\ setFiber ← React.useState' Nothing
    useEffect value do
      dispatch value
      mempty
    let
      load input =
        launchAff_ do
          cancel
          setValue RD.Loading # liftEffect
          fib ←
            forkAff
              $ finally (setFiber Nothing # liftEffect) do
                  result ∷ Either err o ← loadFn input
                  setValue (either RD.Failure RD.Success result) # liftEffect
          setFiber (Just fib) # liftEffect

      cancel = for_ fiber (killFiber (error "Cancelled"))

      reset =
        launchAff_ do
          cancel
          setValue RD.NotAsked # liftEffect
    pure
      { load
      , cancel: reset
      }

useRemoteDataDispatch
  :: ∀ i o err
   . Eq o
  => Eq err
  => ((RemoteData err o) -> Effect Unit)
  → (i → Aff (Either err o))
  → Hook (UseRemoteDataDispatch i err o)
      ( { load ∷ i → Effect Unit
        , cancel ∷ Effect Unit
        }
      )
useRemoteDataDispatch = useRemoteDataDispatchWithDefault Nothing
