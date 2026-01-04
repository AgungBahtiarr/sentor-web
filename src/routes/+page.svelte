<script lang="ts">
    // State variables
    let symbol: string = "BTCUSDT";
    const entryTimeframe: string = "15m";
    let isLoading: boolean = false;
    let result: any = null;
    let meta: any = null;
    let error: string | null = null;

    // Helper to determine signal badge color
    function getSignalClass(signal: string): string {
        if (signal === "BUY") return "badge-success";
        if (signal === "SELL") return "badge-error";
        return "badge-neutral";
    }

    // Helper to get setup phase color
    function getSetupPhaseClass(phase: string): string {
        if (phase === "READY_TO_ENTER") return "badge-success";
        if (phase === "WAITING_FOR_CLOSE") return "badge-warning";
        return "badge-neutral";
    }

    // Helper to get daily bias badge
    function getBiasClass(biasType: string): string {
        if (biasType.includes("BULLISH")) return "badge-success";
        if (biasType.includes("BEARISH")) return "badge-error";
        return "badge-neutral";
    }

    // Main Analyze Function
    async function handleAnalyze() {
        isLoading = true;
        error = null;
        result = null;
        meta = null;

        try {
            const params = new URLSearchParams();
            params.append("symbol", symbol.toUpperCase());
            params.append("timeframe", entryTimeframe);

            const baseUrl = import.meta.env.VITE_API_URL || "";
            const response = await fetch(`${baseUrl}/api/trading/analyze?${params.toString()}`);
            const data = await response.json();

            if (data.success) {
                result = data.data;
                meta = data.meta;
            } else {
                error = data.error || "Failed to fetch data";
            }
        } catch (err: unknown) {
            error = err instanceof Error ? err.message : "Unknown error";
        } finally {
            isLoading = false;
        }
    }
</script>
 
<div class="container mx-auto px-4 py-8 max-w-6xl">
    <div class="text-center mb-8">
        <h1 class="text-4xl font-bold text-primary mb-2">Sentor Trade</h1>
        <p class="text-base-content/70">
            Fractal Model Trading Analysis
        </p>
    </div>
 
    <div class="card bg-base-100 shadow-xl mb-8">
        <div class="card-body">
            <h2 class="card-title text-2xl mb-4">Fractal Analysis Setup</h2>
 
            <div class="grid gap-4">
                <div class="form-control">
                    <label class="label" for="symbol">
                        <span class="label-text font-semibold">Symbol</span>
                    </label>
                    <input
                        type="text"
                        id="symbol"
                        placeholder="BTCUSDT"
                        bind:value={symbol}
                        class="input input-bordered w-full"
                    />
                </div>
 

 
                <button
                    on:click={handleAnalyze}
                    disabled={isLoading}
                    class="btn btn-primary btn-lg w-full"
                >
                    {#if isLoading}
                        <span class="loading-spinner"></span>
                        Analyzing...
                    {:else}
                        Analyze
                    {/if}
                </button>
            </div>
        </div>
    </div>
 
    {#if isLoading}
        <div class="card bg-base-100 shadow-xl mb-8">
            <div class="card-body text-center">
                <div class="loading-spinner loading-lg mx-auto"></div>
                <p class="mt-4">Analyzing fractal market data...</p>
            </div>
        </div>
    {/if}
 
    {#if error}
        <div class="alert alert-error shadow-lg mb-8">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                class="stroke-current shrink-0 h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
            >
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
                />
            </svg>
            <span>{error}</span>
        </div>
    {/if}
 
    {#if result && meta && !isLoading}
        <div class="card bg-base-100 shadow-xl mt-4">
            <div class="card-body">
                <h2 class="card-title text-2xl mb-4">
                    Fractal Analysis - {result.marketData.symbol}
                </h2>
 
                <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4 mb-6">
                    <div class="stat">
                        <div class="stat-title">Current Price</div>
                        <div class="stat-value text-2xl">
                            {result.marketData.currentPrice.toLocaleString()}
                        </div>
                        <div class="stat-desc">
                            {result.marketData.priceChangePercent > 0 ? "+" : ""}
                            {result.marketData.priceChangePercent.toFixed(2)}%
                        </div>
                    </div>
 
                    <div class="stat">
                        <div class="stat-title">Signal</div>
                        <div class="stat-value text-2xl">
                            <span
                                class={`badge ${getSignalClass(result.signal.signal)} badge-lg`}
                            >
                                {result.signal.signal}
                            </span>
                        </div>
                        <div class="stat-desc">
                            Confidence: {result.signal.confidence.toFixed(1)}%
                        </div>
                    </div>
 
                    <div class="stat">
                        <div class="stat-title">Setup Phase</div>
                        <div class="stat-value text-xl">
                            <span
                                class={`badge ${getSetupPhaseClass(meta.setupPhase)} badge-lg`}
                            >
                                {meta.setupPhase}
                            </span>
                        </div>
                        <div class="stat-desc">
                            {meta.setupPhase === "READY_TO_ENTER"
                                ? "All conditions met"
                                : "Waiting for setup"}
                        </div>
                    </div>
 
                    <div class="stat">
                        <div class="stat-title">Daily Bias</div>
                        <div class="stat-value text-xl">
                            <span class={`badge ${getBiasClass(meta.fractalData.dailyBias.type)} badge-lg`}>
                                {meta.fractalData.dailyBias.type}
                            </span>
                        </div>
                        <div class="stat-desc text-xs">
                            {meta.fractalData.dailyBias.type.includes("CONTINUATION")
                                ? "Continuation expected"
                                : meta.fractalData.dailyBias.type.includes("REVERSAL")
                                ? "Reversal expected"
                                : "Neutral bias"}
                        </div>
                    </div>
                </div>
 
                <div class="divider"></div>
 
                <h3 class="text-xl font-semibold mb-4">Timeframe Alignment</h3>
                <div class="grid gap-4 md:grid-cols-3">
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-1">Bias Timeframe</h4>
                            <p class="text-2xl font-bold">{meta.timeframes.bias}</p>
                        </div>
                    </div>
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-1">Structure Timeframe</h4>
                            <p class="text-2xl font-bold">{meta.timeframes.structure}</p>
                        </div>
                    </div>
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-1">Entry Timeframe</h4>
                            <p class="text-2xl font-bold">{meta.timeframes.entry}</p>
                        </div>
                    </div>
                </div>
 
                <div class="divider"></div>
 
                {#if meta.tradeParameters}
                    <h3 class="text-xl font-semibold mb-4">Trade Parameters</h3>
                    <div class="grid gap-4 md:grid-cols-4">
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold mb-1">Entry Zone</h4>
                                <p class="text-2xl font-bold">
                                    {meta.tradeParameters.entryZone.toFixed(2)}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold mb-1">Stop Loss</h4>
                                <p class="text-2xl font-bold text-error">
                                    {meta.tradeParameters.stopLoss.toFixed(2)}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold mb-1">Take Profit</h4>
                                <p class="text-2xl font-bold text-success">
                                    {meta.tradeParameters.takeProfit.toFixed(2)}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold mb-1">Risk:Reward</h4>
                                <p class="text-2xl font-bold">
                                    1:{meta.tradeParameters.riskReward.toFixed(2)}
                                </p>
                                <p class="text-sm mt-1">
                                    {meta.tradeParameters.riskReward >= 2
                                        ? "✅ Valid (≥2:1)"
                                        : "⚠️ Below 2:1"}
                                </p>
                            </div>
                        </div>
                    </div>
                {/if}
 
                <div class="divider"></div>
 
                <div class="grid gap-4 md:grid-cols-2 mb-6">
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-2">Points of Interest (POI)</h4>
                            {#if meta.fractalData.poi.length > 0}
                                <div class="space-y-2">
                                    {#each meta.fractalData.poi.slice(0, 5) as poi}
                                        <div class="flex justify-between items-center">
                                            <span class="font-medium">
                                                {poi.type}
                                            </span>
                                            <span class="badge badge-outline">
                                                {poi.price.toFixed(4)}
                                            </span>
                                        </div>
                                    {/each}
                                </div>
                            {:else}
                                <p class="text-sm text-base-content/60">No POI detected</p>
                            {/if}
                        </div>
                    </div>
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-2">Recent CISD Events</h4>
                            {#if meta.fractalData.cisds.length > 0}
                                <div class="space-y-2">
                                    {#each meta.fractalData.cisds.slice(-3) as cisd}
                                        <div class="text-sm">
                                            <span class={`badge ${cisd.type === "BULLISH" ? "badge-success" : "badge-error"} badge-sm`}>
                                                {cisd.type}
                                            </span>
                                            <span class="ml-2">{cisd.description}</span>
                                        </div>
                                    {/each}
                                </div>
                            {:else}
                                <p class="text-sm text-base-content/60">No recent CISD events</p>
                            {/if}
                        </div>
                    </div>
                </div>
 
                <div class="divider"></div>
 
                <div class="space-y-4">
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-2">Bias Analysis</h4>
                            <p class="text-base-content/80">{meta.biasAnalysis}</p>
                            <div class="mt-3 p-3 bg-base-300 rounded-lg">
                                <p class="text-sm font-medium">
                                    {meta.fractalData.dailyBias.description}
                                </p>
                                <div class="flex gap-4 mt-2 text-sm">
                                    <span>Prev High: {meta.fractalData.dailyBias.previousDay.high.toFixed(2)}</span>
                                    <span>Prev Low: {meta.fractalData.dailyBias.previousDay.low.toFixed(2)}</span>
                                </div>
                            </div>
                        </div>
                    </div>
 
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-2">Structure Validation</h4>
                            <p class="text-base-content/80">{meta.structureValidation}</p>
                        </div>
                    </div>
 
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-2">Setup Confirmation</h4>
                            <p class="text-base-content/80">{meta.setupConfirmation}</p>
                        </div>
                    </div>
 
                    <div class="card bg-base-200">
                        <div class="card-body p-4">
                            <h4 class="font-semibold mb-2">POI Identified</h4>
                            <p class="text-base-content/80">{meta.poiIdentified}</p>
                        </div>
                    </div>
                </div>
 
                <div class="divider"></div>
 
                <div class="card bg-base-200">
                    <div class="card-body p-4">
                        <h4 class="font-semibold mb-2">AI Reasoning</h4>
                        <p class="text-base-content/80">{result.signal.reasoning}</p>
                    </div>
                </div>
 
                <div class="card bg-base-200 mt-4">
                    <div class="card-body p-4">
                        <h4 class="font-semibold mb-2">Risk Considerations</h4>
                        <p class="text-base-content/80">{meta.riskConsiderations}</p>
                    </div>
                </div>
 
                <div class="card bg-base-200 mt-4">
                    <div class="card-body p-4">
                        <h4 class="font-semibold mb-2">Market Summary</h4>
                        <p class="text-base-content/80">{meta.marketSummary}</p>
                    </div>
                </div>
            </div>
        </div>
    {/if}
</div>
 
<style>
    .loading-spinner {
        display: inline-block;
        width: 1rem;
        height: 1rem;
        border: 2px solid currentColor;
        border-right-color: transparent;
        border-radius: 50%;
        animation: spin 0.75s linear infinite;
    }
    @keyframes spin {
        to {
            transform: rotate(360deg);
        }
    }
</style>
