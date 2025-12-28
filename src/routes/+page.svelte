<script>
    // State variables
    let symbol = "BTCUSDT";
    let mode = "normal";
    let timeframe = "15m";
    let higherTimeframe = "4h";

    let isLoading = false;
    let result = null;
    let error = null;

    // Options configuration
    const timeframeOptions = ["1m", "5m", "15m", "30m", "1h", "4h", "1D", "1W"];
    const modeOptions = [
        { value: "normal", label: "Normal" },
        { value: "ict", label: "ICT" },
    ];

    // Helper to determine signal badge color
    function getSignalClass(signal) {
        if (signal === "BUY") return "badge-success";
        if (signal === "SELL") return "badge-error";
        return "badge-neutral";
    }

    // Main Analyze Function
    async function handleAnalyze() {
        isLoading = true;
        error = null;
        result = null;

        try {
            const params = new URLSearchParams();
            params.append("symbol", symbol.toUpperCase());
            params.append("timeframe", timeframe);

            let endpoint = "/api/trading/analyze";

            if (mode === "ict") {
                endpoint = "/api/trading/ict/analyze";
                params.append("higherTimeframe", higherTimeframe);
            }

            const baseUrl = import.meta.env.VITE_API_URL || "";
            const response = await fetch(`${baseUrl}${endpoint}?${params.toString()}`);
            const data = await response.json();

            if (data.success) {
                result = data.data;
            } else {
                error = data.error || "Failed to fetch data";
            }
        } catch (err) {
            error = err.message;
        } finally {
            isLoading = false;
        }
    }
</script>

<div class="container mx-auto px-4 py-8 max-w-6xl">
    <div class="text-center mb-8">
        <h1 class="text-4xl font-bold text-primary mb-2">Sentor Trade</h1>
        <p class="text-base-content/70">
            AI-Powered ICT Trading Analysis Platform
        </p>
    </div>

    <div class="card bg-base-100 shadow-xl mb-8">
        <div class="card-body">
            <h2 class="card-title text-2xl mb-4">Trading Analysis</h2>

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

                <div class="form-control">
                    <label class="label" for="mode">
                        <span class="label-text font-semibold">Mode</span>
                    </label>
                    <select
                        id="mode"
                        bind:value={mode}
                        class="select select-bordered w-full"
                    >
                        {#each modeOptions as option}
                            <option value={option.value}>{option.label}</option>
                        {/each}
                    </select>
                </div>

                <div class="form-control">
                    <label class="label" for="timeframe">
                        <span class="label-text font-semibold">Timeframe</span>
                    </label>
                    <select
                        id="timeframe"
                        bind:value={timeframe}
                        class="select select-bordered w-full"
                    >
                        {#each timeframeOptions as tf}
                            <option value={tf}>{tf}</option>
                        {/each}
                    </select>
                </div>

                {#if mode === "ict"}
                    <div class="form-control">
                        <label class="label" for="higherTimeframe">
                            <span class="label-text font-semibold"
                                >Higher Timeframe</span
                            >
                        </label>
                        <select
                            id="higherTimeframe"
                            bind:value={higherTimeframe}
                            class="select select-bordered w-full"
                        >
                            {#each timeframeOptions as tf}
                                <option value={tf}>{tf}</option>
                            {/each}
                        </select>
                    </div>
                {/if}

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
                <p class="mt-4">Analyzing market data...</p>
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

    {#if result && !isLoading}
        {@const signalType =
            mode === "ict"
                ? result.signal.type
                : result.signal.signal}
        <div class="card bg-base-100 shadow-xl mt-4">
            <div class="card-body">
                <h2 class="card-title">
                    {mode === "ict" ? "ICT" : "Market"} Analysis - {result
                        .marketData.symbol}
                </h2>

                <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
                    <div class="stat">
                        <div class="stat-title">Current Price</div>
                        <div class="stat-value text-2xl">
                            {result.marketData.currentPrice.toLocaleString()}
                        </div>
                        <div class="stat-desc">
                            {result.marketData.priceChangePercent > 0
                                ? "+"
                                : ""}{result.marketData.priceChangePercent.toFixed(
                                2,
                            )}%
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-title">Signal</div>
                        <div class="stat-value text-2xl">
                            <span
                                class={`badge ${getSignalClass(signalType)} badge-lg`}
                            >
                                {signalType}
                            </span>
                        </div>
                        <div class="stat-desc">
                            Confidence: {(
                                result.signal.confidence * 100
                            ).toFixed(1)}%
                        </div>
                    </div>

                    {#if mode === "normal"}
                        <div class="stat">
                            <div class="stat-title">Trend</div>
                            <div class="stat-value text-2xl">
                                {result.trend.trend}
                            </div>
                            <div class="stat-desc">{result.trend.strength}</div>
                        </div>
                    {:else}
                        <div class="stat">
                            <div class="stat-title">Risk/Reward</div>
                            <div class="stat-value text-2xl">
                                {result.signal.riskManagement.riskReward.toFixed(
                                    2,
                                )}
                            </div>
                        </div>
                    {/if}
                </div>

                <div class="divider"></div>

                {#if mode === "normal"}
                    <h3 class="text-xl font-semibold mb-2">
                        Technical Indicators
                    </h3>
                    <div class="grid gap-4 md:grid-cols-2">
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">RSI</h4>
                                <p class="text-2xl">
                                    {result.indicators.rsi.toFixed(2)}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">MACD</h4>
                                <p>
                                    Line: {result.indicators.macd.macdLine.toFixed(
                                        4,
                                    )}
                                </p>
                                <p>
                                    Signal: {result.indicators.macd.signalLine.toFixed(
                                        4,
                                    )}
                                </p>
                                <p>
                                    Histogram: {result.indicators.macd.histogram.toFixed(
                                        4,
                                    )}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">EMA</h4>
                                <p>
                                    EMA 9: {result.indicators.ema.ema9.toFixed(
                                        2,
                                    )}
                                </p>
                                <p>
                                    EMA 21: {result.indicators.ema.ema21.toFixed(
                                        2,
                                    )}
                                </p>
                                <p>
                                    EMA 50: {result.indicators.ema.ema50.toFixed(
                                        2,
                                    )}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">
                                    Support & Resistance
                                </h4>
                                <p>
                                    Nearest Support: {result.supportResistance.nearestSupport.toFixed(
                                        2,
                                    )}
                                </p>
                                <p>
                                    Nearest Resistance: {result.supportResistance.nearestResistance.toFixed(
                                        2,
                                    )}
                                </p>
                            </div>
                        </div>
                    </div>
                {/if}

                {#if mode === "ict"}
                    <h3 class="text-xl font-semibold mb-2">Risk Management</h3>
                    <div class="grid gap-4 md:grid-cols-3">
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Entry</h4>
                                <p class="text-2xl">
                                    {result.signal.riskManagement.entry.toFixed(
                                        2,
                                    )}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Stop Loss</h4>
                                <p class="text-2xl">
                                    {result.signal.riskManagement.stopLoss.toFixed(
                                        2,
                                    )}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Take Profit</h4>
                                <p class="text-2xl">
                                    {result.signal.riskManagement.takeProfit
                                        .map((tp) => tp.toFixed(2))
                                        .join(", ")}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <h3 class="text-xl font-semibold mb-2">ICT Components</h3>
                    <div class="grid gap-4 md:grid-cols-2">
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Fair Value Gaps</h4>
                                <p>
                                    Total: {result.ictAnalysis.fairValueGaps
                                        .length}
                                </p>
                                <p>
                                    Active: {result.ictAnalysis.fairValueGaps.filter(
                                        (fvg) => !fvg.filled,
                                    ).length}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Order Blocks</h4>
                                <p>
                                    Total: {result.ictAnalysis.orderBlocks
                                        .length}
                                </p>
                                <p>
                                    Active: {result.ictAnalysis.orderBlocks.filter(
                                        (ob) => ob.active,
                                    ).length}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Market Structure</h4>
                                <p>
                                    Trend: {result.ictAnalysis.marketStructure
                                        .trend}
                                </p>
                                <p>
                                    Phase: {result.ictAnalysis.marketStructure
                                        .currentStructure.phase}
                                </p>
                            </div>
                        </div>
                        <div class="card bg-base-200">
                            <div class="card-body p-4">
                                <h4 class="font-semibold">Confluence Score</h4>
                                <p>
                                    Bullish: {result.ictAnalysis.confluence
                                        .bullishScore}
                                </p>
                                <p>
                                    Bearish: {result.ictAnalysis.confluence
                                        .bearishScore}
                                </p>
                            </div>
                        </div>
                    </div>
                {/if}

                <div class="divider"></div>

                <h3 class="text-xl font-semibold mb-2">AI Reasoning</h3>
                <div class="alert alert-info">
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        class="stroke-current shrink-0 w-6 h-6"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                        ></path>
                    </svg>
                    <span>{result.signal.reasoning}</span>
                </div>

                {#if mode === "ict" && result.signal.setup}
                    <div class="divider"></div>
                    <h3 class="text-xl font-semibold mb-2">Primary Setup</h3>
                    <div class="alert alert-success">
                        <span>{result.signal.setup.primary}</span>
                    </div>

                    <h3 class="text-xl font-semibold mb-2 mt-4">
                        Confirmations
                    </h3>
                    <ul class="list-disc list-inside">
                        {#each result.signal.setup.confirmations as confirmation}
                            <li>{confirmation}</li>
                        {/each}
                    </ul>

                    <h3 class="text-xl font-semibold mb-2 mt-4">
                        Invalidations
                    </h3>
                    <ul class="list-disc list-inside">
                        {#each result.signal.setup.invalidations as invalidation}
                            <li>{invalidation}</li>
                        {/each}
                    </ul>
                {/if}
            </div>
        </div>
    {/if}
</div>

<style>
    /* Scoped styles for the spinner */
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
